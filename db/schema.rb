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

ActiveRecord::Schema[7.0].define(version: 2023_10_10_104706) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string "iata_code"
    t.string "city"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flight_legs", force: :cascade do |t|
    t.integer "distance"
    t.bigint "flight_id"
    t.bigint "departure_airport_id"
    t.bigint "arrival_airport_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrival_airport_id"], name: "index_flight_legs_on_arrival_airport_id"
    t.index ["departure_airport_id"], name: "index_flight_legs_on_departure_airport_id"
    t.index ["flight_id"], name: "index_flight_legs_on_flight_id"
  end

  create_table "flights", force: :cascade do |t|
    t.string "number", null: false
    t.integer "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "flight_legs", "airports", column: "arrival_airport_id"
  add_foreign_key "flight_legs", "airports", column: "departure_airport_id"
end
