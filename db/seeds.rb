# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

species = Species.create([{common_name: 'lion', binomial: "panthera leo"}, {common_name: 'leopard', binomial: "panthera pardus"}])
Sighting.create(species_id: 1, tribe_id: 1, location_id: 1, drive_id: 1, description: "Something in a tree - was really dangerous", user_id: 1, submission_point: "HQ", record_time: "2012-03-05 19:42:59", time_window_hr: 2)     
Sighting.create(species_id: 2, location_id: 2, drive_id: 1, description: "Out in the plains, sure I saw a McDonalds", user_id: 1, submission_point: "mobile", record_time: "2012-03-05 21:42:59", time_window_hr: 4)     
Tribe.create(name: 'Duma pride', location_id: 2, species_id: 1)
locations = Location.create([{name: 'End of the garden'},{name: 'Other side of the wall'}])
Drive.create(duration_hrs: 3, distance_km: 15, description: 'Round and round')