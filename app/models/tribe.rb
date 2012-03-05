class Tribe < ActiveRecord::Base
  has_many :sightings
  belongs_to :location
end
