class ChangePolygonDataTypeInLocations < ActiveRecord::Migration
  def up
    change_column :locations, :polygon, :text
  end

  def down
  end
end
