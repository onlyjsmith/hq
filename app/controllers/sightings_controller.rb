class SightingsController < ApplicationController
  def index
    @camp_name = "Bumma Camp"
    @sightings = Sighting.all
  end

  def new
    @sighting = Sighting.new
  end

  def edit
  end
end
