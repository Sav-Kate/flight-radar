class RemoveAirportIdFromAirports < ActiveRecord::Migration[7.0]
  def change
    remove_column(:airports, :airport_id)
  end
end
