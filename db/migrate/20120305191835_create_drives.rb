class CreateDrives < ActiveRecord::Migration
  def change
    create_table :drives do |t|
      t.string :route
      t.float :duration_hrs
      t.float :distance_km
      t.string :description

      t.timestamps
    end
  end
end
