class MakeFlightNumberNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:flights, :number, false)
  end
end
