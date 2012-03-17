class HomeController < ApplicationController
  def index
  end
  
  def map
  end
  
  def tester
    @response = TimeParse.parse(params[:time_input]) 
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
