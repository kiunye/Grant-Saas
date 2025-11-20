module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_subscriptions = Subscription.active.count
      @total_revenue = PaymentTransaction.successful.sum(:amount_cents) / 100.0
      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_transactions = PaymentTransaction.includes(:user, subscription: :subscription_plan).order(created_at: :desc).limit(5)
    end
  end
end
