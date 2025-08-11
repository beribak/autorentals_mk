class UpdateExistingCarsWithDefaultSpecs < ActiveRecord::Migration[8.0]
  def change
    # Update existing cars with default values for the new fields
    Car.where(passengers: nil).update_all(passengers: "5")
    Car.where(transmission: nil).update_all(transmission: "Automatic")
    Car.where(gas: nil).update_all(gas: "Petrol")
    Car.where(doors: nil).update_all(doors: "4")
    Car.where(trunk_size: nil).update_all(trunk_size: "Medium")
  end
end
