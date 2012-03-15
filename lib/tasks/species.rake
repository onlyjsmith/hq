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
end
  