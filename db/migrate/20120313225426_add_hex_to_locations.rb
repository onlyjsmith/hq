class AddHexToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :hex, :string

  end
end
