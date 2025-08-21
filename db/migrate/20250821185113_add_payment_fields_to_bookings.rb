class AddPaymentFieldsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :payment_method, :string
    add_column :bookings, :payment_status, :string
  end
end
