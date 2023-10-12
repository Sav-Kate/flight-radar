class ChangeDistanceToFloat < ActiveRecord::Migration[7.0]
  def change
    change_column :flights, :distance, :float
    change_column :flight_legs, :distance, :float
  end
end
