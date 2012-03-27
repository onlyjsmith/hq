class Tribe < ActiveRecord::Base
  has_many :sightings
  belongs_to :location
  belongs_to :species
  
  def self.search(tribe)
    if tribe
      where('name ILIKE ?', "%#{tribe}%")
    else
      all
    end
  end

  def self.by_species(species_id)
    if species_id
      where(:species_id => species_id)
    else
      all
    end
  end
end
