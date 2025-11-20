class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @subscription = current_user.subscription
    @plan = @subscription&.subscription_plan
    @documents = current_user.documents.recent.limit(10)
    @recent_transactions = current_user.payment_transactions.recent.limit(5)
    
    # Usage stats
    @generations_this_month = current_user.generations_this_month
    @remaining_generations = current_user.remaining_generations
  end
end
