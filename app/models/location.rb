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
end
