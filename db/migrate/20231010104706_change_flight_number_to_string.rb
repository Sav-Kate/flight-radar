class ChangeFlightNumberToString < ActiveRecord::Migration[7.0]
  def change
    change_column :flights, :number, :string
  end
end
