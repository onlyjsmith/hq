class CampsController < ApplicationController
  def index
    # TODO: Redirect to "no company page" as fallback instead of selecting the first company
    @company = Company.find(session[:company_id]) || Company.first

    # TODO: Scope this to only the company's camps - this doesn't feel like the right way, but it works
    @camps = Camp.company_camps(@company.id)

    @sightings = @camps.all.map{|e| e.sightings}.flatten
    
    # TODO: Calculate the interesting stats for the company
    # @most_sightings_camp = @camps.
  end
          
  # TODO: Replace this with Camp HEADLINES - for now redirects to sightings#index 
  def show
    session[:camp_id] = params[:id]
    redirect_to sightings_path
  end
end
