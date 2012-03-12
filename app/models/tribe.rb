class Tribe < ActiveRecord::Base
  has_many :sightings
  belongs_to :location
  belongs_to :species
end
