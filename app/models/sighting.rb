class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  # belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp
end
