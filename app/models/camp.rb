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
  
  def location
    # Make this dynamic, once Cartodb linked up to locations and camps properly
    location_id = 195826 # For Duba Plains, Botswana

    result = CartoDB::Connection.query "SELECT the_geom FROM sites where id = #{location_id}"
    result[:rows][0][:the_geom].as_json
  end
end
