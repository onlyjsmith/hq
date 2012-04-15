class Reporting::ReportsController < ApplicationController
  def index
    @q = Sighting.search(params[:q])
    @sightings = @q.result(:distinct => true).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html
      format.json  { 
        render :json => {
          :current_page => @sightings.current_page,
          :per_page => @sightings.per_page,
          :total_entries => @sightings.total_entries,
          :entries => @sightings 
          }, 
          :callback => params[:callback] 
        }
    end
  end
end