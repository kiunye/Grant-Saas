class PaymentTransaction < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :subscription

  # Validations
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :paystack_reference, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[success failed pending] }

  # Scopes
  scope :successful, -> { where(status: 'success') }
  scope :failed, -> { where(status: 'failed') }
  scope :recent, -> { order(transaction_date: :desc) }

  # Get amount in human-readable format
  def amount
    amount_cents / 100.0
  end

  # Check if transaction was successful
  def successful?
    status == 'success'
  end

  # Check if transaction failed
  def failed?
    status == 'failed'
  end
end
