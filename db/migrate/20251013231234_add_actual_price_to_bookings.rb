class AddActualPriceToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :actual_price, :decimal
  end
end
