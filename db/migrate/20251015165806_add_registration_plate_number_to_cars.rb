class AddRegistrationPlateNumberToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :registration_plate_number, :string
  end
end
