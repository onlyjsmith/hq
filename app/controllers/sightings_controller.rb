class SightingsController < ApplicationController
  def index
    @user = "Bob"
    @camp = Camp.first
    @drive_count = Drive.count
    @sightings = Sighting.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sightings }
    end
  end

  def show
    @sighting = Sighting.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.json { render json: @sighting}
    end
  end

  def new
    @sighting = Sighting.new
  end

  def edit
  end
end
