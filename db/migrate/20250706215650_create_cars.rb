class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.string :brand
      t.string :model
      t.integer :year
      t.decimal :price_per_day
      t.text :description
      t.string :image_url
      t.boolean :available

      t.timestamps
    end
  end
end
