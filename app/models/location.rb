require 'SecureRandom'

class Location < ActiveRecord::Base
  has_many :sightings
  has_many :tribes
  # TODO: Location <-> Camp should be a location-based association, dynamic
  has_many :camps
  
  #before_save :update_geom_to_cartodb

  def self.search(location)
    if location
      where('name ILIKE ?', "%#{location}%")
    else
      all
    end
  end
  
  
  def geom
    
    result = CartoDB::Connection.query "SELECT the_geom FROM locations where hex = '#{self.hex}'", :page => 1
    result[:rows][0][:the_geom].as_json
    
  end
  
  
  protected
  def update_geom_to_cartodb
    
    #create unique token to match two systems:
    key = SecureRandom.hex(50)
    #update or insert geom into cartodb then make the value null
    
    
    
    #check hex is there already then update or insert accordingly
    q = "INSERT INTO locations (hex, the_geom) VALUES ('#{key}', ST_SetSRID(ST_GeomFromGeoJSON('#{self.polygon}'), 4326));"
    
    CartoDB::Connection.query q
    self.polygon = nil
    self.hex = key
    
  end
  
  
end
