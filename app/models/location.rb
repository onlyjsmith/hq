require 'SecureRandom'

class Location < ActiveRecord::Base
  has_many :sightings
  has_many :tribes
  # TODO: Location <-> Camp should be a location-based association, dynamic
  has_many :camps


  validates :name, :presence => true

  after_initialize :default_values
  before_save :update_geom_to_cartodb
  after_save :update_ids_to_cartodb

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
  
  def self.search_by_bb(bb)

    result = CartoDB::Connection.query "SELECT loc_id FROM locations where ST_Intersect(the_geom, ST_MakeEnvelope(bb[0], bb[1], bb[2], bb[3], 4326))"
    
    
    puts result
    
    result[:rows][0][:the_geom].as_json
  
  
  end
  
  

  
  def geom 
    result = CartoDB::Connection.query "SELECT the_geom FROM locations where loc_id = '#{self.id}'", :page => 1
    result[:rows][0][:the_geom].as_json
  end
  
  
  
  
  protected
  def update_geom_to_cartodb
     
    #check hex is there already then update or insert accordingly
    # Including name in INSERT just for debugging and development
    q = "INSERT INTO locations (the_geom) VALUES (ST_SetSRID(ST_GeomFromGeoJSON('#{self.polygon}'), 4326)) RETURNING cartodb_id;"      
    response = CartoDB::Connection.query q
    self.cartodb_id = response[:rows][0][:cartodb_id]
    self.polygon = nil
    
  end
  
  def update_ids_to_cartodb
    
    #adds the location id to the cartodb table
    q = "UPDATE locations SET loc_id  = #{self.id} WHERE cartodb_id = #{self.cartodb_id};"
    response = CartoDB::Connection.query q
    
  end
  
  
  
  private
  
  def default_values
  end

  
  
end
