class CreateFlightLegs < ActiveRecord::Migration[7.0]
  def change
    create_table :flight_legs do |t|
      t.integer :distance

      t.belongs_to :flight
      t.references :departure_airport
      t.references :arrival_airport

      t.timestamps
    end
    add_foreign_key :flight_legs, :airports, column: :departure_airport_id, primary_key: :id
    add_foreign_key :flight_legs, :airports, column: :arrival_airport_id, primary_key: :id
  end
end
