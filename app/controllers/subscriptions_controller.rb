class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @subscription = current_user.subscription
    @plan = @subscription&.subscription_plan
    @available_plans = SubscriptionPlan.all.order(:price_cents)
  end

  def new
    @plans = SubscriptionPlan.paid.order(:price_cents)
    @current_plan = current_user.subscription&.subscription_plan
  end

  def create
    plan = SubscriptionPlan.find(params[:subscription_plan_id])
    
    # Initialize Paystack subscription
    result = PaystackService.new(current_user).create_subscription(plan)
    
    if result[:success]
      redirect_to result[:authorization_url]
    else
      flash[:alert] = result[:error]
      redirect_to new_subscription_path
    end
  end

  def cancel
    if current_user.subscription&.cancel!
      # Also cancel on Paystack
      PaystackService.new(current_user).cancel_subscription
      flash[:notice] = 'Subscription canceled successfully'
    else
      flash[:alert] = 'Failed to cancel subscription'
    end
    redirect_to subscriptions_path
  end

  def reactivate
    plan_id = params[:plan_id]
    plan = SubscriptionPlan.find(plan_id)
    
    result = PaystackService.new(current_user).create_subscription(plan)
    
    if result[:success]
      redirect_to result[:authorization_url]
    else
      flash[:alert] = result[:error]
      redirect_to subscriptions_path
    end
  end
end
