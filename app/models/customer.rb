class Customer < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :cars, through: :bookings

  # Validations
  validates :first_name, :last_name, :email, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone, format: { with: /\A[\+]?[\d\s\-\(\)]{7,20}\z/ }

  # Clean phone number before validation
  before_validation :clean_phone_number

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def active_bookings
    bookings.active
  end

  def booking_history
    bookings.where(status: [ :completed, :cancelled ])
  end

  private

  def clean_phone_number
    return unless phone.present?

    # Remove any non-digit, non-plus characters except spaces, dashes, parentheses
    # This allows common formats but removes invalid characters
    self.phone = phone.strip
  end
end
