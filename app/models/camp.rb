class Camp < ActiveRecord::Base 
  belongs_to :company
  belongs_to :location
  has_many :sightings
  
  # default_scope where(:company_id => session[:company_id])
      
  def self.company_camps(company_id)
    # debugger
    if company_id
      Company.find(company_id).camps
    else 
      all
    end
  end
  
  def nearby_locations
    start_coords = self.location_point
    buffer = 0.05

    sql = "SELECT loc_id FROM locations where ST_Intersects(the_geom, ST_MakeEnvelope(#{bb[1]}, #{bb[0]}, #{bb[3]}, #{bb[2]}, 4326))"           

    response = CartoDB::Connection.query sql

    result = response[:rows].map{|x| x[:loc_id]}
    
    
  end
  
  # Returns location of camp as a point
  def location_point# (id=195826)
    # Make this dynamic, once Cartodb linked up to locations and camps properly
    # location_id = 195826 # For Duba Plains, Botswana
    # puts cartodb_id
    result = CartoDB::Connection.query "SELECT ST_AsGeoJSON(the_geom) AS pnt FROM sites WHERE cartodb_id = #{cartodb_id}"
    JSON.parse result[:rows][0][:pnt]
  end
  
  
  
  
  
end
