class CreateSightings < ActiveRecord::Migration
  def change
    create_table :sightings do |t|
      t.integer :species_id
      t.integer :tribe_id
      t.integer :location_id
      t.integer :drive_id
      t.string :description
      t.integer :user_id
      t.string :submission_point

      t.timestamps
    end
  end
end
