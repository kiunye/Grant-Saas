Rails.application.routes.draw do
  get "grants/new"
  get "grants/create"
  get "documents/index"
  get "documents/show"
  get "documents/edit"
  get "documents/update"
  get "documents/destroy"
  get "subscriptions/index"
  get "subscriptions/new"
  get "subscriptions/create"
  get "dashboard/index"
  get "home/index"
  # Devise for users with OmniAuth
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Root path
  root 'home#index'

  # Authenticated user routes
  authenticate :user do
    # User Dashboard
    get 'dashboard', to: 'dashboard#index', as: :user_dashboard

    # Subscription management
    resources :subscriptions, only: [:index, :new, :create] do
      member do
        post :cancel
        post :reactivate
      end
    end

    # Grant generation workflow
    resources :grants, only: [:new, :create] do
      collection do
        get :step1
        post :save_step1
        get :step2
        post :save_step2
        get :step3
        post :generate
      end
    end

    # Document management
    resources :documents, only: [:index, :show, :edit, :update, :destroy] do
      member do
        get :export_pdf
        get :export_docx
      end
    end

    # Payment history
    resources :payment_transactions, only: [:index]
  end

  # Admin Dashboard
  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :users, only: [:index, :show]
    resources :subscriptions, only: [:index, :show]
    resources :transactions, only: [:index]
    resources :analytics, only: [:index]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
