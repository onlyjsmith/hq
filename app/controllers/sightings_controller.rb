class SightingsController < ApplicationController
  def index
    @user = "Bob"
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
