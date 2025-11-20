class SubscriptionPlan < ApplicationRecord
  # Associations
  has_many :subscriptions, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :allows_export, inclusion: { in: [true, false] }

  # Scopes
  scope :free, -> { where(price_cents: 0) }
  scope :paid, -> { where('price_cents > 0') }

  # Check if plan allows unlimited generations
  def unlimited_generations?
    generations_per_month.nil? || generations_per_month == -1
  end

  # Get price in human-readable format
  def price
    price_cents / 100.0
  end

  # Check if this is the free trial plan
  def free_trial?
    price_cents.zero?
  end
end
