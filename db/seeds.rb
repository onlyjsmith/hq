# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# species = Species.create([{common_name: 'lion', binomial: "panthera leo"}, {common_name: 'leopard', binomial: "panthera pardus"}])
# Sighting.create(species_id: 1, tribe_id: 1, location_id: 1, drive_id: 1, description: "Something in a tree - was really dangerous", user_id: 1, submission_point: "HQ", record_time: "2012-03-05 19:42:59", time_window_hr: 2, camp_id: 1)     
# Sighting.create(species_id: 2, location_id: 2, drive_id: 1, description: "Out in the plains, sure I saw a McDonalds", user_id: 1, submission_point: "mobile", record_time: "2012-03-05 21:42:59", time_window_hr: 4, camp_id: 1)     
# Tribe.create(name: 'Duma pride', location_id: 2, species_id: 1)
# locations = Location.create([{name: 'End of the garden'},{name: 'Other side of the wall'}])
# Drive.create(duration_hr: 3, distance_km: 15, description: 'Round and round')                
# Camp.create(name: 'Wonderland Camp', company_id: 1)
# Company.create(name: 'Wildplaces')


User.create({:email=> 'jonathan@peoplesized.com', :password=>'egg', :password_confirmation=>'egg'}).save(:validate=> false)

Species.create(:id => 2, :common_name => "leopard", :binomial => "panthera pardus")
Species.create(:id => 3, :common_name => "dog", :binomial => "dogus maximus")
Species.create(:id => 4, :common_name => "elephant", :binomial => "loxodonta africana")
Species.create(:id => 5, :common_name => "sitatunga", :binomial => "tragelaphus spekeii")
Species.create(:id => 1, :common_name => "lion", :binomial => "panthera leo")


Company.create(:id => 1, :name => "Wildplaces")

Camp.create(:id => 1, :name => "Wonderland Camp", :company_id => 1)


Location.create(:id => 1, :name => "End of the garden")
Location.create(:id => 2, :name => "Other side of the wall")
Location.create(:id => 3, :name => "Basic place")
Location.create(:id => 4, :name => "Right far in the distance")

Photo.create(:id => 44, :url => "http://farm4.staticflickr.com/3272/3103490954_4ea4fe5ffe_m.jpg", :imageable_id => 2, :imageable_type => 0)
Photo.create(:id => 45, :url => "http://farm5.staticflickr.com/4134/4929201434_56074060a8_m.jpg", :imageable_id => 3, :imageable_type => 0)
Photo.create(:id => 46, :url => "http://farm4.staticflickr.com/3609/3385334129_9ac670d131_m.jpg", :imageable_id => 4, :imageable_type => 0)
Photo.create(:id => 47, :url => "http://farm8.staticflickr.com/7024/6709414735_f12a0fcc20_m.jpg", :imageable_id => 5, :imageable_type => 0)
Photo.create(:id => 48, :url => "http://farm3.staticflickr.com/2071/2048143444_fb846df337_m.jpg", :imageable_id => 1, :imageable_type => 0)


Sighting.create(:id => 1, :species_id => 1, :tribe_id => 1, :location_id => 1, :drive_id => 1, :description => "Something in a tree - was really dangerous", :user_id => 1, :submission_point => "HQ", :record_time => "Mon, 05 Mar 2012 19:42:59 UTC +00:00", :time_window_hr => 2, :camp_id => 1)
Sighting.create(:id => 2, :species_id => 2, :location_id => 2, :drive_id => 1, :description => "Out in the plains, sure I saw a McDonalds", :user_id => 1, :submission_point => "mobile", :record_time => "Mon, 05 Mar 2012 21:42:59 UTC +00:00", :time_window_hr => 4, :camp_id => 1)
Sighting.create(:id => 3, :species_id => 1, :tribe_id => 1, :location_id => 1, :drive_id => 1, :description => "in a bit of a hurry", :user_id => 1, :submission_point => "Mobile", :record_time => "Sun, 11 Mar 2012 07:57:00 UTC +00:00", :time_window_hr => 4, :camp_id => 1)



Tribe.create(:id => 1, :name => "Duma pride", :location_id => 2, :species_id => 4)
Tribe.create(:id => 2, :name => "Omelette", :location_id => 3, :species_id => 5)



