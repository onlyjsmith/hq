require 'SecureRandom'

class Location < ActiveRecord::Base
  has_many :sightings
  has_many :tribes
  # TODO: Location <-> Camp should be a location-based association, dynamic
  has_many :camps

  validates :name, :presence => true
  attr_accessor :from_point
  
  # after_initialize :default_values
  before_save :update_geom_to_cartodb
  after_save :update_ids_to_cartodb

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
  
  # Search for all records within bounding box
  def self.search_by_bounding_box(bb)
    sql = "SELECT loc_id FROM locations where ST_Intersects(the_geom, ST_MakeEnvelope(#{bb[1]}, #{bb[0]}, #{bb[3]}, #{bb[2]}, 4326))"           
    response = CartoDB::Connection.query sql
    
    locations = []

    response[:rows].each do |row|
      id = row[:loc_id]
      if Location.exists?(id)
        name = Location.find(id).name
      else
        name = "Location doesn't exist in local DB"
      end
      loc = {:label => name, :id => id}
      locations << loc
      # loc = Location.find(id[:loc_id])
      # locations << { :label => loc.name, :value => loc.id }
    end
    # debugger
    locations
  end
  
  # Search for all locations under coords
  def self.find_by_coords(coords)
    if coords
      sql = "SELECT loc_id FROM locations WHERE ST_Intersects(the_geom, ST_geomfromtext('POINT(#{coords[1]} #{coords[0]})', 4326))"
      response = CartoDB::Connection.query sql
      # debugger
      result = response[:rows].map{|x| x[:loc_id]}
      
      locations = []
      result.each do |res|
        locations << res
      end
      locations
    else
      locations = []
      all.each do |x|
        locations << x.id
      end
    end
  end
  
  # Creates a new location on CartoDB, with default buffer, from point coords
  def self.create_from_point(coords)
    location = Location.new
    # debugger

    buffer = 0.01 # degrees
    name = "Buffered point site"
    sql = "INSERT INTO locations (the_geom, loc_id, name) 
      VALUES (ST_Multi(ST_Buffer(ST_SetSRID(ST_Point(#{coords[1]}, #{coords[0]}),4326),#{buffer}, 2)), -1, '#{name}')
      RETURNING cartodb_id"
    response = CartoDB::Connection.query sql
    location.cartodb_id = response[:rows][0][:cartodb_id]
    location.name = "Buffered point site"
    location.polygon = nil
    location
  end

  
  def geom 
    result = CartoDB::Connection.query "SELECT the_geom FROM locations where loc_id = '#{self.id}'", :page => 1
    result[:rows][0][:the_geom].as_json
  end
  
  protected
  def update_geom_to_cartodb
    # FIXME: Following line is very brittle
    unless self.name == "Buffered point site"
      # TODO: Add hex stuff back in
      q = "INSERT INTO locations (the_geom) VALUES (ST_SetSRID(ST_GeomFromGeoJSON('#{self.polygon}'), 4326)) RETURNING cartodb_id;"      
      response = CartoDB::Connection.query q
      self.cartodb_id = response[:rows][0][:cartodb_id]
      self.polygon = nil
    end
  end
  
  def update_ids_to_cartodb
    
    #adds the location id to the cartodb table
    q = "UPDATE locations SET loc_id  = #{self.id} WHERE cartodb_id = #{self.cartodb_id};"
    response = CartoDB::Connection.query q
    
  end
  
  
end
