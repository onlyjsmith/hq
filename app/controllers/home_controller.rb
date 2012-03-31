class HomeController < ApplicationController
  def index
  end
  
  def redirect
    item_id = params[:id]

    case params[:model]
    when 'species'
      redirect_to species_path(item_id)
    when 'tribe'
      redirect_to species_tribe_path(Tribe.find(item_id))
    when 'camp'
      redirect_to camp_path(item_id)
    when 'location'
      redirect_to location_path(item_id)
    end
  end
  
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
