namespace :camp do
  desc "Import sites from existing cartodb table"
  task :import_sites_from_cartodb => :environment do
    result = CartoDB::Connection.query "SELECT name FROM sites"
    result[:rows].each do |row|
      Camp.create(:name => row[:name])
      print "."
    end
    puts "Created #{result[:rows].count} Camps from cartodb"
  end
end