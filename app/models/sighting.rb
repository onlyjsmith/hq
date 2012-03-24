class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  # belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp
  
  def self.filter_time(filter_time)
    if filter_time
      where("record_time > ?", (Date.today - filter_time.to_i))
    else
      all
    end
  end
  
  def self.by_camp(camp)
    if camp
      where(:camp_id => camp.id)
    else
      all
    end
  end
end
