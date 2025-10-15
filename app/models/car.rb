class Car < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :customers, through: :bookings

  validates :brand, presence: true
  validates :model, presence: true
  validates :year, presence: true, numericality: { greater_than: 1900 }
  validates :price_per_day, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :image_url, presence: true
  validates :registration_plate_number, presence: true

  scope :available, -> { where(available: true) }
  scope :by_brand, ->(brand) { where("brand ILIKE ?", "%#{brand}%") }

  def full_name
    "#{brand} #{model} (#{year})"
  end

  def formatted_price
    "€#{price_per_day}/day"
  end

  def available_for_dates?(start_date, end_date)
    return false unless available?

    overlapping_bookings = bookings.active.for_date_range(start_date, end_date)
    !overlapping_bookings.exists?
  end

  def next_available_date
    last_booking = bookings.active.order(:end_date).last
    last_booking ? last_booking.end_date + 1.day : Date.current
  end

  def currently_available?
    # Check if car is marked as available AND has no active bookings that include today
    return false unless available?

    today = Date.current
    current_bookings = bookings.active.where("start_date <= ? AND end_date >= ?", today, today)
    !current_bookings.exists?
  end

  def upcoming_bookings
    bookings.active.where("start_date > ?", Date.current).order(:start_date)
  end

  def current_booking
    today = Date.current
    bookings.active.where("start_date <= ? AND end_date >= ?", today, today).first
  end
end
