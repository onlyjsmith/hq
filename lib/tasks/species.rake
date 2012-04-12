namespace :species do
  desc "Removes all species photos and rebuilds URL DB from Flickr"
  task :get_all_species_photos => :environment do
    print "Deleting all existing species photos"
    Species.all.each do |species|
      species.photos.destroy_all
      print "."
    end
    print "\nGetting all new photos"

    Species.all.each do |species|
      species.get_photo_url
      print "+"
    end
  end
  
  desc "Imports common Southern African species with scientific names"
  task :import_sa_species => :environment do
    puts "Loading data"
    file = File.open(File.join(Rails.root, "lib", "data", "species_sa_import.csv"), 'r')
    data = CSV.parse file
    data.each do |d|  
      print "."
      Species.create(:binomial => d[0], :common_name => d[1])
    end
    puts "Completed loading #{data.count} species"
  end
end
  