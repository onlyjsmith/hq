namespace :populate do
  desc "Do all - WARNING, trashes database. But then fills it with nice things."
  task :all => :environment do
    # Static
    Rake::Task["populate:static"].execute

    # Camps
    Rake::Task["camp:import_sites_from_cartodb"].execute
    # Rake::Task["camp:destroy_camp_buffers"].execute
    # Rake::Task["camp:create_buffers"].execute

    # Species
    Rake::Task["species:clear_and_import_sa_species"].execute
    Rake::Task["species:get_all_species_photos"].execute
    
    # Geo
    Rake::Task["populate:destroy_buffered_points"].execute
    Rake::Task["populate:generate_random_camp_locations"].execute
    Rake::Task["populate:sightings"].execute
    
  end

  desc "Populate Heroku only"
  task :heroku => :environment do
    # Static
    Rake::Task["populate:static"].execute

    # Camps
    puts "Doing camp import from cartodb"
    Rake::Task["camp:import_sites_from_cartodb"].execute
    # Rake::Task["camp:destroy_camp_buffers"].execute
    # Rake::Task["camp:create_buffers"].execute

    # Species
    Rake::Task["species:clear_and_import_sa_species"].execute
    Rake::Task["species:get_all_species_photos"].execute
    
    # Geo
    # Rake::Task["populate:destroy_buffered_points"].execute
    # Rake::Task["populate:generate_random_camp_locations"].execute
    Rake::Task["populate:sightings"].execute
    
  end

  
  desc "Destroy and Populate Company and User"
  task :static => :environment do
    Company.destroy_all
    5.times do 
      name = Faker::Company.name
      Company.create(:name => name)
    end
    
    User.destroy_all
    # Add clients
    20.times do
      f = Faker::Name.first_name
      l = Faker::Name.last_name
      e = Faker::Internet.email(f + " " + l)
      r = 'Client'
      u = User.new(:first_name => f, :surname => l, :email => e)
      u.save!(:validate => false)
    end

    # Add guides
    5.times do
      f = Faker::Name.first_name
      l = Faker::Name.last_name
      e = Faker::Internet.email(f + " " + l)
      r = 'Guide'
      u = User.new(:first_name => f, :surname => l, :email => e)
      u.save!(:validate => false)
    end
  end
  
  desc "Populate Geo: Location"
  task :generate_random_camp_locations => :environment do
    # create 10 locations randomly for each camp
    Camp.all.each do |camp|
      puts "Generating 30 locations for ##{camp.id}"
      30.times {Location.random_from_camp(camp.id)}
      puts
      # break
    end
    
  end
  
  desc "Delete Geo: locations for camps"
  task :destroy_buffered_points => :environment do
    load "#{::Rails.root.to_s}/lib/cartodb_connect.rb"
    CartoDB::Connection.query "DELETE FROM locations WHERE name ILIKE '%Buffered%'"
    puts "Destroyed camp buffers"
  end
  
  desc "Populate Sightings (500)"
  task :sightings => :environment do
    # TODO Add sightings task.
    date = Time.now - 60.days
    Camp.all.each do |camp|
      puts "Creating sightings for camp #{camp.id}"
      30.times do
        # Random species
        offset = rand(Species.count)
        species_id = Species.first(:offset => offset).id
        
        # Random location
        offset = rand(Location.count)
        location_id = Location.first(:offset => offset).id

        description = Faker::Lorem.sentence
        
        # Random user
        offset = rand(User.count)
        user_id = User.first(:offset => offset).id
        
        time_step_hrs = rand(12)
        date = date + time_step_hrs.hours
        record_time = date

        sighting = Sighting.create(:camp_id => camp.id, :species_id => species_id, :location_id => location_id, :description => description, :user_id => user_id, :record_time => record_time)
        print "."
      end
      # break
      
    end
  end
end