class MakeIataNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:airports, :iata, false)
  end
end
