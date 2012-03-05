class AddTimeToSighting < ActiveRecord::Migration
  def change
    add_column :sightings, :record_time, :datetime
    add_column :sightings, :time_window_hrs, :integer
  end
end
