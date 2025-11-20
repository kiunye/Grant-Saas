module Admin
  class SubscriptionsController < BaseController
    include Pagy::Backend

    def index
      @pagy, @subscriptions = pagy(Subscription.includes(:user, :subscription_plan).order(created_at: :desc))
    end
  end
end
