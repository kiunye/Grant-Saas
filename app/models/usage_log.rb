class UsageLog < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :action, presence: true
  validates :created_month, presence: true

  # Set created_month before creation
  before_create :set_created_month

  private

  def set_created_month
    self.created_month = Time.current.strftime("%Y-%m")
  end
end
