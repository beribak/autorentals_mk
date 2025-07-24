class BookingInquiriesController < ApplicationController
  before_action :set_car, only: [ :new, :create ]

  def new
    @inquiry = {
      start_date: params[:start_date],
      end_date: params[:end_date],
      car_id: @car&.id
    }
  end

  def create
    @inquiry = inquiry_params
    @inquiry[:car_id] = @car&.id

    if valid_inquiry?(@inquiry)
      # Send email to company
      BookingInquiryMailer.new_inquiry(@inquiry).deliver_now

      # Send confirmation to customer
      BookingInquiryMailer.inquiry_confirmation(@inquiry).deliver_now

      redirect_to confirmation_booking_inquiries_path, notice: "Вашето барање е успешно испратено!"
    else
      flash.now[:alert] = "Ве молиме пополнете ги сите задолжителни полиња."
      render :new
    end
  end

  def confirmation
  end

  private

  def set_car
    @car = Car.find(params[:car_id]) if params[:car_id]
  end

  def inquiry_params
    params.require(:inquiry).permit(:first_name, :last_name, :email, :phone, :start_date, :end_date, :pickup_location, :message)
  end

  def valid_inquiry?(inquiry)
    inquiry[:first_name].present? &&
    inquiry[:last_name].present? &&
    inquiry[:email].present? &&
    inquiry[:phone].present? &&
    inquiry[:start_date].present? &&
    inquiry[:end_date].present?
  end
end
