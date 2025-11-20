module Admin
  class TransactionsController < BaseController
    include Pagy::Backend

    def index
      @pagy, @transactions = pagy(PaymentTransaction.includes(:user, subscription: :subscription_plan).order(created_at: :desc))
    end
  end
end
