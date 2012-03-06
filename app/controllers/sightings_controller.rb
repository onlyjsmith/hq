class SightingsController < ApplicationController
  def index
    @camp_name = "Bumma Camp" 
    @drive_count = 3
    @sightings = Sighting.all
  end

  def new
    @sighting = Sighting.new
  end

  def edit
  end
end
