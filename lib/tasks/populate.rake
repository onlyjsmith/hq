namespace :populate do
  desc "Do all"
  task :all => :environment do
    # Static
    Rake::Task["populate:static"].execute

    # Camps
    Rake::Task["camp:import_sites_from_cartodb"].execute
    Rake::Task["camp:destroy_camp_buffers"].execute
    Rake::Task["camp:create_buffers"].execute

    # Species
    Rake::Task["species:clear_and_import_sa_species"].execute
    
    
    # Geo
  end

  desc "Populate Company(10) and User(50)"
  task :static => :environment do
    Company.destroy_all
    500.times do 
      name = Faker::Company.name
      Company.create(:name => name)
    end
    
    50.times do
      f = Faker::Name.first_name
      l = Faker::Name.last_name
      e = Faker::Internet.email(f + " " + l)
      u = User.new(:first_name => f, :surname => l, :email => e)
      u.save!(:validate => false)
    end
  end
  
  desc "Populate Geo: Location"
  task :geo => :environment do
    # TODO Add geo task. Use GeoIpsum?
  end
  
  desc "Populate Sightings (500)"
  task :sightings => :environment do
    # TODO Add sightings task.
  end
end