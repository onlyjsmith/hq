class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  # belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp
  
  def self.search(search)
    puts "Search term: #{search}" 
    if search
      find(:all, :conditions => ['record_time > ?', (Date.today - search.to_i)])
    else
      find(:all)
    end
  end
end
