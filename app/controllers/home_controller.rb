class HomeController < ApplicationController
  def index
  end
  
  def redirect
    id = params[:id]

    case params[:model]
    when 'species'
      redirect_to species_path(id)
    when 'tribe'
      redirect_to species_tribe_path(Tribe.find(id))
    when 'camp'
      redirect_to camp_path(id)
    when 'location'
      redirect_to location_path(id)
    end
  end
  # def tester
  #   @response = TimeParse.parse(params[:time_input]) 
  # end
  
  def auto_search
    @search_response = Home.search(params[:term])
    # debugger
    respond_to do |format|
      format.json {
        # debugger
        # Rails.logger.debug { "response to json is #{@search_response.to_json}" }
        render :json => @search_response.as_json
      }
    end
  end
end
