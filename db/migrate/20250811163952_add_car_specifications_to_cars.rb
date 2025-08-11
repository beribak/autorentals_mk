class AddCarSpecificationsToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :passengers, :string
    add_column :cars, :transmission, :string
    add_column :cars, :gas, :string
    add_column :cars, :doors, :string
    add_column :cars, :trunk_size, :string
  end
end
