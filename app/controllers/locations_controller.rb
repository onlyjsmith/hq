class LocationsController < ApplicationController
  
  def index
    @locations = Location.search(params[:search])
    @search = Location.new
    # puts "SEARCH TERMZ: #{@search.class}"
  end
  
  def new
    @location = Location.new
  end
  
end
