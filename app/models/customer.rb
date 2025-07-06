class Customer < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :cars, through: :bookings

  # Validations
  validates :first_name, :last_name, :email, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone, format: { with: /\A[\+]?[1-9][\d]{0,15}\z/ }

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
end
