class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.decimal :total_price
      t.integer :status
      t.string :pickup_location
      t.string :dropoff_location
      t.text :special_requests
      t.string :stripe_payment_intent_id

      t.timestamps
    end
  end
end
