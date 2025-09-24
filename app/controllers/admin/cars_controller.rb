class Admin::CarsController < Admin::ApplicationController
  before_action :set_car, only: [ :show, :edit, :update, :destroy, :toggle_availability, :create_booking, :destroy_booking, :bookings ]

  def index
    @cars = Car.all.order(:brand, :model)
    @total_cars = @cars.count
    @available_cars = @cars.where(available: true).count
    @total_revenue = @cars.sum(:price_per_day)
  end

  def show
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)

    if @car.save
      redirect_to admin_cars_path, notice: "Car was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @booking = Booking.new
    @booking.car = @car
    set_booking_data
  end

  def update
    if @car.update(car_params)
      redirect_to admin_cars_path, notice: "Car was successfully updated."
    else
      @booking = Booking.new
      @booking.car = @car
      set_booking_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy
    redirect_to admin_cars_path, notice: "Car was successfully deleted."
  end

  # Toggle availability action
  def toggle_availability
    @car = Car.find(params[:id])
    @car.update(available: !@car.available?)

    status = @car.available? ? "available" : "unavailable"
    redirect_to admin_cars_path, notice: "Car has been marked as #{status}."
  end

  # Create booking action for admins
  def create_booking
    # Extract customer parameters with the correct prefix
    customer_params = {
      customer_first_name: params[:booking_customer_first_name],
      customer_last_name: params[:booking_customer_last_name],
      customer_email: params[:booking_customer_email],
      customer_phone: params[:booking_customer_phone]
    }

    booking_params = params.require(:booking).permit(:start_date, :end_date, :pickup_location, :special_requests)

    # Find or create customer
    @customer = Customer.find_by(email: customer_params[:customer_email])
    if @customer.nil?
      @customer = Customer.new(
        first_name: customer_params[:customer_first_name],
        last_name: customer_params[:customer_last_name],
        email: customer_params[:customer_email],
        phone: customer_params[:customer_phone]
      )

      unless @customer.save
        @booking = Booking.new(booking_params)
        @booking.car = @car
        @booking.errors.add(:base, "Customer validation failed: #{@customer.errors.full_messages.join(', ')}")
        set_booking_data
        render :edit, status: :unprocessable_entity
        return
      end
    end

    # Create booking
    @booking = @customer.bookings.new(booking_params)
    @booking.car = @car
    @booking.status = :confirmed  # Admin bookings are automatically confirmed

    if @booking.save
      redirect_to edit_admin_car_path(@car), notice: "Booking successfully created for #{@customer.full_name}."
    else
      set_booking_data
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete booking action for admins
  def destroy_booking
    @booking = @car.bookings.find(params[:booking_id])
    customer_name = @booking.customer.full_name

    @booking.destroy
    redirect_to edit_admin_car_path(@car), notice: "Резервацијата на #{customer_name} е успешно избришана."
  end

  # Show all bookings for a specific car
  def bookings
    @all_bookings = @car.bookings.includes(:customer).order(:start_date)
    @pending_bookings = @all_bookings.where(status: :pending)
    @confirmed_bookings = @all_bookings.where(status: :confirmed)
    @completed_bookings = @all_bookings.where(status: :completed)
    @cancelled_bookings = @all_bookings.where(status: :cancelled)
    @future_bookings = @all_bookings.where("start_date >= ?", Date.current)
    @past_bookings = @all_bookings.where("start_date < ?", Date.current)

    # Calculate stats
    @total_revenue = @confirmed_bookings.sum(&:total_price)

    # Calculate average duration manually since duration_in_days is a method
    if @all_bookings.any?
      total_duration = @all_bookings.sum { |booking| (booking.end_date - booking.start_date).to_i + 1 }
      @average_duration = (total_duration.to_f / @all_bookings.count).round(1)
    else
      @average_duration = 0
    end
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def set_booking_data
    @existing_bookings = @car.bookings.includes(:customer).order(:start_date)
    @future_bookings = @car.bookings.includes(:customer)
                          .where("start_date >= ?", Date.current)
                          .where(status: [ :pending, :confirmed, :in_progress ])
                          .order(:start_date)
  end

  def car_params
    params.require(:car).permit(:brand, :model, :year, :price_per_day, :description, :image_url, :available, :passengers, :transmission, :gas, :doors, :trunk_size)
  end
end
