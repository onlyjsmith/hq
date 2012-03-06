class RemoveCentrePointFromLocations < ActiveRecord::Migration
  def up
    change_table :locations do |t|
      t.remove :centre_point, :radius_km, :distance_from_centre_point_km, :direction
    end
  end

  def down
  end
end
