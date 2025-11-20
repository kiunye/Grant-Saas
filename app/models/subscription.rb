class Subscription < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :subscription_plan
  has_many :payment_transactions, dependent: :destroy

  # Validations
  validates :status, presence: true, inclusion: { in: %w[active canceled past_due inactive] }

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: ['canceled', 'inactive', 'past_due']) }

  # Check if subscription is active
  def active?
    status == 'active'
  end

  # Check if subscription is past due
  def past_due?
    status == 'past_due'
  end

  # Check if subscription is canceled
  def canceled?
    status == 'canceled'
  end

  # Cancel subscription
  def cancel!
    update(status: 'canceled')
  end

  # Reactivate subscription
  def reactivate!
    update(status: 'active')
  end

  # Mark as past due
  def mark_past_due!
    update(status: 'past_due')
  end
end
