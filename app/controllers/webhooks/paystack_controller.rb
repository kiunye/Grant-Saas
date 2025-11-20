class Webhooks::PaystackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_paystack_signature

  def create
    event_type = params[:event]
    data = params[:data]

    case event_type
    when 'charge.success'
      handle_successful_payment(data)
    when 'subscription.create'
      handle_subscription_created(data)
    when 'subscription.disable'
      handle_subscription_disabled(data)
    when 'invoice.payment_failed'
      handle_payment_failed(data)
    end

    head :ok
  end

  private

  def verify_paystack_signature
    signature = request.headers['X-Paystack-Signature']
    secret = ENV['PAYSTACK_SECRET_KEY']
    
    computed_signature = OpenSSL::HMAC.hexdigest('SHA512', secret, request.raw_post)
    
    unless signature == computed_signature
      render json: { error: 'Invalid signature' }, status: :unauthorized
    end
  end

  def handle_successful_payment(data)
    reference = data['reference']
    customer_email = data['customer']['email']
    amount = data['amount']

    user = User.find_by(email: customer_email)
    return unless user

    # Create payment transaction
    user.payment_transactions.create!(
      subscription: user.subscription,
      amount_cents: amount,
      currency: data['currency'],
      paystack_reference: reference,
      status: 'success',
      transaction_date: Time.current
    )

    # Activate subscription if it was inactive
    if user.subscription && !user.subscription.active?
      user.subscription.reactivate!
    end
  end

  def handle_subscription_created(data)
    customer_code = data['customer']['customer_code']
    subscription_code = data['subscription_code']

    user = User.joins(:subscription).find_by(subscriptions: { paystack_customer_code: customer_code })
    return unless user

    user.subscription.update(
      paystack_subscription_code: subscription_code,
      status: 'active',
      next_payment_date: data['next_payment_date']
    )
  end

  def handle_subscription_disabled(data)
    subscription_code = data['subscription_code']
    
    subscription = Subscription.find_by(paystack_subscription_code: subscription_code)
    return unless subscription

    subscription.cancel!
  end

  def handle_payment_failed(data)
    customer_email = data['customer']['email']
    
    user = User.find_by(email: customer_email)
    return unless user

    # Mark subscription as past due
    user.subscription.mark_past_due! if user.subscription

    # You might want to send an email notification here
  end
end
