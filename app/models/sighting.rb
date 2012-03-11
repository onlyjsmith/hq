class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  # belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp
  
  def self.search(search)
    if search
      where("record_time > ?", (Date.today - search.to_i))
    else
      all
    end
  end
end
