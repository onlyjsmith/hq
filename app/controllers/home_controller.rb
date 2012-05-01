class HomeController < ApplicationController
  http_basic_authenticate_with :name => "ws", :password => "ws"
  def index
  end
  
  def redirect
    # TODO: Find another way to pass parameters from home#redirect to sightings#index without using POST
    redirect_to sightings_path("q[#{params[:model]}_id_eq]" => params[:id])
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
