class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Handles Google OAuth2 callback
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      # Create free trial subscription if user doesn't have one
      unless @user.subscription
        free_plan = SubscriptionPlan.find_by(name: 'Free Trial')
        @user.create_subscription!(
          subscription_plan: free_plan,
          status: 'active'
        )
      end

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  # Handle OAuth failures
  def failure
    redirect_to root_path, alert: 'Authentication failed. Please try again.'
  end
end
