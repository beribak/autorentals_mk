class BookingsController < ApplicationController
  before_action :set_booking, only: [ :show, :edit, :update, :destroy, :cancel ]
  before_action :set_car, only: [ :new, :create ]

  def index
    @bookings = Booking.includes(:customer, :car).order(created_at: :desc)
  end

  def show
  end

  def new
    @booking = @car.bookings.build
    @customer = Customer.new

    # Pre-fill dates if provided
    if params[:start_date].present? && params[:end_date].present?
      @booking.start_date = Date.parse(params[:start_date]) rescue nil
      @booking.end_date = Date.parse(params[:end_date]) rescue nil
    end
  end

  def create
    @customer = find_or_create_customer

    if @customer.nil? || @customer.errors.any?
      @booking = @car.bookings.build(booking_params)
      render :new, status: :unprocessable_entity
      return
    end

    @booking = @car.bookings.build(booking_params)
    @booking.customer = @customer
    @booking.status = :pending

    if @booking.save
      redirect_to booking_path(@booking), notice: "Booking was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    if @booking.can_be_cancelled?
      @booking.update(status: :cancelled)
      redirect_to @booking, notice: "Booking has been cancelled."
    else
      redirect_to @booking, alert: "This booking cannot be cancelled."
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_path, notice: "Booking was successfully deleted."
  end

  # AJAX endpoint for checking car availability
  def check_availability
    car = Car.find(params[:car_id])
    start_date = Date.parse(params[:start_date]) rescue nil
    end_date = Date.parse(params[:end_date]) rescue nil

    if start_date && end_date && car
      available = car.available_for_dates?(start_date, end_date)
      duration = (end_date - start_date).to_i + 1
      total_price = car.price_per_day * duration if available

      render json: {
        available: available,
        total_price: total_price,
        price_per_day: car.price_per_day,
        duration: available ? duration : nil
      }
    else
      render json: { error: "Invalid parameters" }, status: :bad_request
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_car
    @car = Car.find(params[:car_id]) if params[:car_id]
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :pickup_location, :dropoff_location, :special_requests)
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :address, :city, :state, :zip_code, :country)
  end

  def find_or_create_customer
    # Try to find existing customer by email
    customer = Customer.find_by(email: customer_params[:email])

    if customer
      # Update customer info if found
      customer.update(customer_params)
      customer
    else
      # Create new customer (don't use create! to avoid exceptions)
      customer = Customer.new(customer_params)
      customer.save
      customer
    end
  end
end
