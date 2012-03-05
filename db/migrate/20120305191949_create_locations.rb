class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :centre_point
      t.string :polygon
      t.float :radius_km
      t.float :distance_from_centre_point_km
      t.string :direction

      t.timestamps
    end
  end
end
