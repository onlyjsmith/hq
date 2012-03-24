class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  # belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp
  
  def self.filter_time(filter_time)
    # debugger
    if filter_time
      where("record_time > ?", (Date.today - filter_time.to_i))
    else
      all
    end
  end
end
