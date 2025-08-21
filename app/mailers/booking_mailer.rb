class BookingMailer < ApplicationMailer
  default from: "bookings@autorentals.mk"

  def customer_confirmation(booking)
    @booking = booking
    @customer = booking.customer
    @car = booking.car

    mail(
      to: @customer.email,
      subject: "Потврда за резервација ##{@booking.id} - AutoRentalsMK"
    )
  end

  def company_notification(booking)
    @booking = booking
    @customer = booking.customer
    @car = booking.car

    # Use environment variable for company email, fallback to default
    company_email = ENV.fetch("COMPANY_EMAIL", "contact@autorentals.mk")

    mail(
      to: company_email,
      subject: "Нова резервација ##{@booking.id} - #{@customer.full_name}"
    )
  end
end
