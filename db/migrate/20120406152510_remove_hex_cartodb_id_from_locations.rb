class RemoveHexCartodbIdFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :hex
    remove_column :locations, :cartodb_id
  end

  def down
    add_column :locations, :cartodb_id, :integer
    add_column :locations, :hex, :string
  end
end
