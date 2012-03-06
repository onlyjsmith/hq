class AddCampIdToSightings < ActiveRecord::Migration
  def change
    add_column :sightings, :camp_id, :integer
  end
end
