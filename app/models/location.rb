require 'SecureRandom'

class Location < ActiveRecord::Base
  has_many :sightings
  has_many :tribes
  # TODO: Location <-> Camp should be a location-based association, dynamic
  has_many :camps
  
  # before_save :update_geom_to_cartodb

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  # Returns either cartodb_id of location or false
  def self.store_poly_to_cartodb(params)
    geojson = JSON.load(params[:geojson])
    cartodb_id = params[:cartodb_id] || false
    poly = geojson['coordinates'][0][0]

    begin
      # close the loop
      poly.append(poly[0])
      # check to enforce that all numeric values were supplied
      poly = poly.map{|p| "#{p[0]} #{p[1]}"}

      if cartodb_id == false
        sql = "INSERT INTO locations (the_geom) " + 
          "VALUES (GEOMETRYFROMTEXT('MULTIPOLYGON(((#{poly.join(',')})))',4326)) " +
          "RETURNING cartodb_id"
      else
        sql = "UPDATE locations SET the_geom = GEOMETRYFROMTEXT('MULTIPOLYGON(((#{poly.join(',')})))',4326) " +
          "WHERE cartodb_id = #{cartodb_id}"
      end
      
      # debugger
      response = CartoDB::Connection.query sql
      cartodb_id ||= response[:rows][0][:cartodb_id]
    rescue
      return false
      # self.error(500)
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
    # Including name in INSERT just for debugging and development
    q = "INSERT INTO locations (hex, the_geom) VALUES ('#{key}', ST_SetSRID(ST_GeomFromGeoJSON('#{self.polygon}'), 4326)) RETURNING cartodb_id;"
    
    response = CartoDB::Connection.query q

    self.cartodb_id = response[:rows][0][:cartodb_id]
    self.polygon = nil
    self.hex = key
    
  end
  
  
end
