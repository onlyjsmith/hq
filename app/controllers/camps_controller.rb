class CampsController < ApplicationController
  def index
    # Scopes by company if exists.
    # @company = Company.find(params[:company_id]) if params[:company_id]
    # @camps = Camp.company_camps(@company)

    @camps = Camp.all
    # @sightings = @camps.all.map{|e| e.sightings}.flatten
    
    # TODO: Calculate the interesting stats for the company
    # @most_sightings_camp = @camps.
  end
          
  def show
    @camp = Camp.find(params[:id])
  end
end
