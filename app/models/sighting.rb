class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  # belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp
  
  def self.filter_by(time, species_id)
    # debugger
    filter_time(time)
    by_species(species_id)
  end

  def self.filter_time(time)
    if time
      where("record_time > ?", (Date.today - time.to_i))
    else
      all
    end
  end

  def self.by_species(species_id)
    if species_id
      where("species_id = ?", species_id)
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
