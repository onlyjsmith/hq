class Reporting::CampsController < ApplicationController
  def index
    @q = Sighting.search(params[:q])
    @sightings = @q.result(:distinct => true).paginate(:per_page => 5, :page => params[:page])
    @camps = Camp.all
    
    
    respond_to do |format|
      format.html { render '/reporting/camps' }
      format.json { render json: @sightings}
    end
  end
  
  def show
    # debugger
    @q = Sighting.search(:camp_id_eq => params[:id])
    @sightings = @q.result(:distinct => true).order('record_time DESC').paginate(:per_page => 5, :page => params[:page])
    @camp = Camp.find(params[:id])
    
    respond_to do |format|
      format.json { render :json => 
        {
        :camp_name =>  @camp.name,
        :report_date => Time.now,
        :sightings => @sightings
        }
      }
    end
  end
end