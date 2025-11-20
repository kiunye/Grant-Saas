class Document < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :status, inclusion: { in: %w[draft completed] }, allow_nil: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :completed, -> { where(status: 'completed') }
  scope :drafts, -> { where(status: 'draft') }

  # Set default status
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= 'completed'
  end
end
