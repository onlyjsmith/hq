class Location < ActiveRecord::Base
  has_many :sightings
  has_many :tribes
end
