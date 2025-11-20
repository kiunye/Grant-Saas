class HomeController < ApplicationController
  def index
    # Redirect to dashboard if user is signed in
    redirect_to user_dashboard_path if user_signed_in?
    
    # Otherwise show landing page with pricing
    @plans = SubscriptionPlan.all.order(:price_cents)
  end
end
