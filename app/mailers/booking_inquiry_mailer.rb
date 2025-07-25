class BookingInquiryMailer < ApplicationMailer
  default from: "contact@autorentals.mk"

  def new_inquiry(inquiry_params)
    @inquiry = inquiry_params
    @car = Car.find(@inquiry[:car_id]) if @inquiry[:car_id]

    mail(
      to: "contact@autorentals.mk",
      subject: "Ново барање за резервација - #{@car&.full_name || 'Општо барање'}"
    )
  end

  def inquiry_confirmation(inquiry_params)
    @inquiry = inquiry_params
    @car = Car.find(@inquiry[:car_id]) if @inquiry[:car_id]

    mail(
      to: @inquiry[:email],
      subject: "Потврда за вашето барање - autorentalsMK"
    )
  end
end
