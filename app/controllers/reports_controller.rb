class ReportsController < ApplicationController
  def index
    @q = Sighting.search(params[:q])
    # @sightings = @q.result(:distinct => true).paginate(:per_page => 5, :page => params[:page])
    @sightings = Sighting.find(:all, :limit => 20)
    
  end
end