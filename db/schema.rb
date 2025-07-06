# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_06_230410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "car_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.decimal "total_price"
    t.integer "status"
    t.string "pickup_location"
    t.string "dropoff_location"
    t.text "special_requests"
    t.string "stripe_payment_intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_bookings_on_car_id"
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.integer "year"
    t.decimal "price_per_day"
    t.text "description"
    t.string "image_url"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "cars"
  add_foreign_key "bookings", "customers"
end
