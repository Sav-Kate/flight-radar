class CreateAirports < ActiveRecord::Migration[7.0]
  def change
    create_table :airports do |t|
      t.string :iata_code
      t.string :city
      t.string :country
      t.float :latitude
      t.float :longitude

      t.belongs_to :airport

      t.timestamps
    end
  end
end
