namespace :camp do
  desc "Destroy all then import sites from existing cartodb table"
  task :import_sites_from_cartodb => :environment do
    load "#{::Rails.root.to_s}/lib/cartodb_connect.rb"
    puts "Destroying all existing camps"
    Camp.destroy_all

    # Try to figure out if deploying to heroku or not...
    
    result = CartoDB::Connection.query "SELECT cartodb_id, name FROM sites WHERE company IS NOT null"
    result[:rows].each do |row|
      offset = rand(Company.count)
      company = Company.first(:offset => offset)

      Camp.create(:name => row[:name], :cartodb_id => row[:cartodb_id], :company_id => company.id)
      print "."
    end
    puts "Created #{result[:rows].count} Camps from cartodb"
  end
  
  desc "Destroy buffered locations for camps in cartodb"
  task :destroy_camp_buffers => :environment do
    load "#{::Rails.root.to_s}/lib/cartodb_connect.rb"
    CartoDB::Connection.query "DELETE FROM locations WHERE camp_id IS NOT null"
    puts "Destroyed camp buffers"
  end
  

  desc "Create buffered Locations in cartodb for each Camp"
  task :create_buffers => :environment do
    load "#{::Rails.root.to_s}/lib/cartodb_connect.rb"
    100.times do 
      result = CartoDB::Connection.query "SELECT lng, lat, cartodb_id, name FROM sites"
      result[:rows].each do |row|
        c = Camp.where(:cartodb_id => row[:cartodb_id]).first
        puts "Buffering for ##{c.id}: #{c.name}"
        # buffer = 0.001 # degrees
        c.name = c.name
        # Making buffer larger for visibility to test with
        buffer = 0.01 # degrees
        name = "Buffered point near #{c.name}"
        sql = "INSERT INTO locations (the_geom, camp_id, name) 
          VALUES (ST_Multi(ST_Buffer(ST_SetSRID(ST_Point(#{row[:lng]}, #{row[:lat]}),4326),#{buffer}, 4)), '#{c.id}', '#{c.name.gsub("'","''")}')
          RETURNING cartodb_id"
        CartoDB::Connection.query sql

        print "."
      end
    end
  end
end