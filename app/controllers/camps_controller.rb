class CampsController < ApplicationController
  def index
    # debugger                                   

    # TODO: Stop this selecting only the first company!
    @company = session[:company] || Company.first

    @camps = Camp.all

    @sightings = Camp.all.map{|e| e.sightings}.flatten
  end
          
  # TODO: Replace this with Camp HEADLINES - for now redirects to sightings#index 
  def show
    # debugger
    session[:camp_id] = params[:id]
    redirect_to sightings_path
  end
end
