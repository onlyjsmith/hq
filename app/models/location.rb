class Location < ActiveRecord::Base
  has_many :sightings
  has_many :tribes
  has_many :camps
  
  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
  
  
  def geom
    
    result = CartoDB::Connection.query "SELECT the_geom FROM locations where loc_id = #{self.id}", :page => 1
    result[:rows][0][:the_geom].as_json
    
  end
  
  
  
end
