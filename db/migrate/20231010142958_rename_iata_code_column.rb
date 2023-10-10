class RenameIataCodeColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :airports, :iata_code, :iata
  end
end
