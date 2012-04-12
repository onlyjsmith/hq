namespace :camp do
  desc "Destroy all then import sites from existing cartodb table"
  task :import_sites_from_cartodb => :environment do
    puts "Destroying all existing camps"
    Camp.destroy_all
    result = CartoDB::Connection.query "SELECT cartodb_id, name FROM sites"
    result[:rows].each do |row|
      Camp.create(:name => row[:name], :cartodb_id => row[:cartodb_id])
      print "."
    end
    puts "Created #{result[:rows].count} Camps from cartodb"
  end
  
  desc "Create buffered Locations in cartodb for each Camp"
  task :create_buffers => :environment do
    count = 0
    result = CartoDB::Connection.query "SELECT lng, lat, cartodb_id, name FROM sites"
    result[:rows].each do |row|
      c = Camp.where(:cartodb_id => row[:cartodb_id]).first
      puts "Buffering for ##{c.id}: #{c.name}"
      # buffer = 0.001 # degrees
      c.name = c.name
      # Making buffer larger for visibility to test with
      buffer = 0.01 # degrees
      name = "Buffered point site"
      sql = "INSERT INTO locations (the_geom, camp_id, name) 
        VALUES (ST_Multi(ST_Buffer(ST_SetSRID(ST_Point(#{row[:lng]}, #{row[:lat]}),4326),#{buffer}, 4)), '#{c.id}', '#{c.name.gsub("'","''")}')
        RETURNING cartodb_id"
      CartoDB::Connection.query sql

      print "."
      count += 1
      break if count > 100
    end
  end
  
  desc "Destroy buffered locations created for camps in cartodb"
  task :destroy_camp_buffers => :environment do
    CartoDB::Connection.query "DELETE FROM locations WHERE camp_id IS NOT null"
    puts "Done"
  end
end