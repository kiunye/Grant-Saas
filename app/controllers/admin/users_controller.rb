module Admin
  class UsersController < BaseController
    include Pagy::Backend

    def index
      @pagy, @users = pagy(User.order(created_at: :desc))
    end

    def show
      @user = User.find(params[:id])
      @subscription = @user.subscription
      @documents = @user.documents.order(created_at: :desc).limit(10)
      @transactions = @user.payment_transactions.order(created_at: :desc).limit(10)
    end
  end
end
