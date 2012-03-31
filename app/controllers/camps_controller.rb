class CampsController < ApplicationController
  def index
    # Scopes by company if exists.
    # @company = Company.find(params[:company_id]) if params[:company_id]
    # @camps = Camp.company_camps(@company)
    
    # debugger
    @camps = Camp.company_camps(session[:company_id])
    # @camps = Camp.all
    # @sightings = @camps.all.map{|e| e.sightings}.flatten
    
    # TODO: Calculate the interesting stats for the company
    # @most_sightings_camp = @camps.
  end
          
  def show
    @camp = Camp.find(params[:id])
    @sightings = Sighting.where(:camp_id => @camp.id)
    # if @sightings.nil?
    #   @sightings = Sighting.all
    # end
    
  end
end
