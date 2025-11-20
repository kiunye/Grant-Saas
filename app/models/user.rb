class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Associations
  has_one :subscription, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :usage_logs, dependent: :destroy
  has_many :payment_transactions, dependent: :destroy

  # Delegations
  delegate :subscription_plan, to: :subscription, allow_nil: true

  # OmniAuth callback
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # Check if user can generate documents
  def admin?
    admin
  end

  def can_generate?
    return false unless subscription&.active?
    
    plan = subscription.subscription_plan
    return true if plan.unlimited_generations?
    
    generations_this_month < plan.generations_per_month
  end

  # Get count of generations this month
  def generations_this_month
    current_month = Time.current.strftime("%Y-%m")
    usage_logs.where(action: 'generate', created_month: current_month).count
  end

  # Get remaining generations for this month
  def remaining_generations
    plan = subscription&.subscription_plan
    return 0 unless plan
    return Float::INFINITY if plan.unlimited_generations?
    
    [plan.generations_per_month - generations_this_month, 0].max
  end

  # Check if user can export documents
  def can_export?
    subscription&.active? && subscription.subscription_plan.allows_export?
  end

  # Check if subscription is active
  def subscription_active?
    subscription&.active?
  end
end
