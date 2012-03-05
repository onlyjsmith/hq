# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

species = Species.create([{common_name: 'lion'}, {common_name: 'leopard'}])
Sighting.create(species_id: 1, tribe_id: 1, location_id: 1, drive_id: 1, description: "Something in a tree - was really dangerous", user_id: 1, submission_point: "HQ", record_time: "2012-03-05 19:42:59", time_window_hrs: 2)     
Tribe.create(name: 'Duma pride', location_id: 2, species_id: 1)
locations = Location.create([{name: 'End of the garden'},{name: 'Other side of the wall'}])
Drive.create(duration_hrs: 3, distance_km: 15, description: 'Round and round')