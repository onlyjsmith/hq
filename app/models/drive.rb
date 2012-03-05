class Drive < ActiveRecord::Base
  has_many :sightings
  # belongs_to :trip
end
