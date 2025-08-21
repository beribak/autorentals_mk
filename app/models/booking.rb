class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :car

  # Enum for booking status
  enum :status, {
    pending: 0,
    confirmed: 1,
    in_progress: 2,
    completed: 3,
    cancelled: 4,
    refunded: 5
  }

  # Enum for payment status
  enum :payment_status, {
    payment_pending: 0,
    payment_paid: 1,
    payment_failed: 2,
    payment_cancelled: 3,
    payment_refunded: 4
  }

  # Validations
  validates :start_date, :end_date, presence: true
  validates :pickup_location, presence: true
  validate :end_date_after_start_date
  validate :start_date_not_in_past
  validate :car_available_for_dates, on: :create

  # Remove total_price validation since it's calculated automatically

  # Scopes
  scope :active, -> { where(status: [ :pending, :confirmed, :in_progress ]) }
  scope :for_date_range, ->(start_date, end_date) { where("start_date < ? AND end_date > ?", end_date, start_date) }

  # Callbacks
  before_validation :calculate_total_price
  # Remove the automatic availability marking - let date-range validation handle this

  # Instance methods
  def duration_in_days
    (end_date - start_date).to_i + 1
  end

  def can_be_cancelled?
    pending? || confirmed?
  end

  def customer_name
    "#{customer.first_name} #{customer.last_name}"
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  def start_date_not_in_past
    return unless start_date

    errors.add(:start_date, "cannot be in the past") if start_date < Date.current
  end

  def car_available_for_dates
    return unless car && start_date && end_date

    overlapping_bookings = car.bookings.active.for_date_range(start_date, end_date)
    overlapping_bookings = overlapping_bookings.where.not(id: id) if persisted?

    errors.add(:base, "Car is not available for the selected dates") if overlapping_bookings.exists?
  end

  def dates_changed?
    start_date_changed? || end_date_changed?
  end

  def calculate_total_price
    return unless car && start_date && end_date

    self.total_price = car.price_per_day * duration_in_days
  end
end
