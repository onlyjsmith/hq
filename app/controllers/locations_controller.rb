class LocationsController < ApplicationController
  
  def index
    @locations = Location.search(params[:search])
  end
  
  def new
    @location = Location.new
  end
end
