class PaystackService
  attr_reader :user

  def initialize(user)
    @user = user
    @secret_key = ENV['PAYSTACK_SECRET_KEY']
  end

  # Create a new subscription
  def create_subscription(plan)
    begin
      # Create customer if doesn't exist
      customer_code = get_or_create_customer

      # Initialize transaction
      response = initialize_transaction(plan, customer_code)
      
      if response['status']
        # Create or update subscription record
        subscription = user.subscription || user.build_subscription
        subscription.update(
          subscription_plan: plan,
          paystack_customer_code: customer_code,
          status: 'inactive' # Will be activated by webhook
        )

        {
          success: true,
          authorization_url: response['data']['authorization_url'],
          reference: response['data']['reference']
        }
      else
        { success: false, error: response['message'] }
      end
    rescue => e
      { success: false, error: e.message }
    end
  end

  # Cancel subscription
  def cancel_subscription
    return { success: false, error: 'No active subscription' } unless user.subscription

    begin
      subscription_code = user.subscription.paystack_subscription_code
      
      if subscription_code
        # Cancel on Paystack
        url = "https://api.paystack.co/subscription/#{subscription_code}"
        response = make_request(:post, "#{url}/disable")
        
        if response['status']
          user.subscription.cancel!
          { success: true }
        else
          { success: false, error: response['message'] }
        end
      else
        user.subscription.cancel!
        { success: true }
      end
    rescue => e
      { success: false, error: e.message }
    end
  end

  private

  def get_or_create_customer
    return user.subscription.paystack_customer_code if user.subscription&.paystack_customer_code

    # Create customer on Paystack
    response = make_request(:post, 'https://api.paystack.co/customer', {
      email: user.email,
      first_name: user.email.split('@').first
    })

    if response['status']
      response['data']['customer_code']
    else
      raise "Failed to create customer: #{response['message']}"
    end
  end

  def initialize_transaction(plan, customer_code)
    # Note: Paystack subscriptions work by charging the customer
    # We initialize a transaction that will create the subscription
    make_request(:post, 'https://api.paystack.co/transaction/initialize', {
      email: user.email,
      amount: plan.price_cents,
      currency: 'KES',
      plan: plan.stripe_price_id, # This should be Paystack plan code
      callback_url: "#{ENV['APP_HOST']}/subscriptions",
      metadata: {
        user_id: user.id,
        plan_id: plan.id,
        custom_fields: [
          {
            display_name: 'Plan',
            variable_name: 'plan',
            value: plan.name
          }
        ]
      }
    })
  end

  def make_request(method, url, body = nil)
    require 'net/http'
    require 'json'

    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = case method
              when :get
                Net::HTTP::Get.new(uri.request_uri)
              when :post
                Net::HTTP::Post.new(uri.request_uri)
              end

    request['Authorization'] = "Bearer #{@secret_key}"
    request['Content-Type'] = 'application/json'
    request.body = body.to_json if body

    response = http.request(request)
    JSON.parse(response.body)
  end
end
