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

    # TODO: Add the following line back in to redirect to sightings_index with search terms
    # redirect_to sightings_path("q[camp_id_eq]" => @camp.id)
  end
  
  # def search
  #   @camp = Camp.search(params[:search])
  #   respond_to do |format|
  #     format.json { render json: @camp}
  #   end
  # end
end
