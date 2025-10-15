class BookingsController < ApplicationController
  before_action :set_booking, only: [ :show, :edit, :update, :destroy, :cancel, :payment_success, :payment_cancel ]
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

    # Always initialize @booking with the form params
    @booking = @car.bookings.build(booking_params)

    if @customer.nil?
      @customer = Customer.new(params[:customer]) if params[:customer].present?
      flash.now[:alert] = "Please provide valid customer information."
      render :new, status: :unprocessable_entity
      return
    end

    if @customer.errors.any?
      render :new, status: :unprocessable_entity
      return
    end

    @booking.customer = @customer
    @booking.status = :pending
    @booking.payment_status = :payment_pending

    if @booking.save
      # Handle payment method
      if @booking.payment_method == "pay_now"
        redirect_to_stripe_checkout
      else
        # Pay on pickup - send emails and redirect
        send_booking_emails
        redirect_to booking_path(@booking), notice: "Booking was successfully created!"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @customer = @booking.customer
    @car = @booking.car
  end

  def update
    @customer = @booking.customer
    @car = @booking.car

    # Update customer information if provided
    if params[:customer].present?
      unless @customer.update(customer_params)
        render :edit, status: :unprocessable_entity
        return
      end
    end

    # Allow past dates for booking updates (typically done by admins)
    @booking.allow_past_dates!

    if @booking.update(booking_params)
      redirect_to edit_booking_path(@booking), notice: "Booking was successfully updated."
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

  def payment_success
    session_id = params[:session_id]

    begin
      # Retrieve the Stripe session to verify payment
      stripe_session = Stripe::Checkout::Session.retrieve(session_id)

      if stripe_session.payment_status == "paid"
        @booking.update!(
          payment_status: :payment_paid,
          stripe_payment_intent_id: session_id
        )

        # Send confirmation emails after successful payment
        send_booking_emails

        redirect_to booking_path(@booking), notice: "Payment successful! Your booking is confirmed."
      else
        @booking.update!(payment_status: :payment_failed)
        redirect_to booking_path(@booking), alert: "Payment verification failed. Please contact support."
      end
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe verification error: #{e.message}"
      @booking.update!(payment_status: :payment_failed)
      redirect_to booking_path(@booking), alert: "Payment verification failed. Please contact support."
    end
  end

  def payment_cancel
    @booking.update!(payment_status: :payment_cancelled)
    redirect_to new_car_booking_path(@booking.car), alert: "Payment was cancelled. You can try again or choose 'Pay on Pickup'."
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
    params.require(:booking).permit(:start_date, :end_date, :pickup_location, :special_requests, :payment_method, :actual_price)
  end

  def customer_params
    customer_data = params.require(:customer).permit(:first_name, :last_name, :email, :phone)

    # Convert empty strings to nil for optional fields
    customer_data[:email] = nil if customer_data[:email].blank?
    customer_data[:phone] = nil if customer_data[:phone].blank?

    customer_data
  end

  def find_or_create_customer
    # Check if customer params are present
    return nil unless params[:customer].present?

    begin
      customer_data = customer_params

      # Only try to find existing customer if email is provided
      customer = nil
      if customer_data[:email].present?
        customer = Customer.find_by(email: customer_data[:email])
      end

      if customer
        # Update customer info if found
        if customer.update(customer_data)
          customer
        else
          # Return customer with errors if update failed
          customer
        end
      else
        # Create new customer
        customer = Customer.new(customer_data)
        customer.save
        customer
      end
    rescue ActionController::ParameterMissing => e
      Rails.logger.error "Missing customer parameters: #{e.message}"
      nil
    rescue => e
      Rails.logger.error "Error in find_or_create_customer: #{e.message}"
      nil
    end
  end

  def redirect_to_stripe_checkout
    begin
      # Calculate total price
      duration = (@booking.end_date - @booking.start_date).to_i + 1
      total_price_cents = (@booking.car.price_per_day * duration * 100).to_i

      # Create Stripe checkout session
      session = Stripe::Checkout::Session.create({
        payment_method_types: [ "card" ],
        line_items: [ {
          price_data: {
            currency: "eur",
            product_data: {
              name: "Car Rental: #{@booking.car.full_name}",
              description: "#{duration} days rental from #{@booking.start_date} to #{@booking.end_date}"
            },
            unit_amount: total_price_cents
          },
          quantity: 1
        } ],
        mode: "payment",
        success_url: payment_success_booking_url(@booking, session_id: "{CHECKOUT_SESSION_ID}"),
        cancel_url: payment_cancel_booking_url(@booking),
        client_reference_id: @booking.id.to_s,
        customer_email: @booking.customer.email,
        metadata: {
          booking_id: @booking.id
        }
      })

      # Store the Stripe session ID
      @booking.update!(stripe_payment_intent_id: session.id)

      # Log the redirect URL for debugging
      Rails.logger.info "Redirecting to Stripe checkout: #{session.url}"

      # Redirect to Stripe checkout
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error: #{e.message}"
      @booking.update(payment_status: :payment_failed)
      flash[:alert] = "Payment processing failed. Please try again or choose 'Pay on Pickup'."
      render :new, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "Error creating Stripe session: #{e.message}"
      flash[:alert] = "An error occurred. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  def send_booking_emails
    begin
      # Send confirmation email to customer
      BookingMailer.customer_confirmation(@booking).deliver_now

      # Send notification email to company
      BookingMailer.company_notification(@booking).deliver_now
    rescue => e
      Rails.logger.error "Failed to send booking emails: #{e.message}"
      # Don't fail the booking if emails fail
    end
  end
end
