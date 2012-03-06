class SightingsController < ApplicationController
  def index
    @camp = Camp.first
    @drive_count = Drive.count
    @sightings = Sighting.all
  end

  def new
    @sighting = Sighting.new
  end

  def edit
  end
end
