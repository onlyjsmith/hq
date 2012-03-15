class HomeController < ApplicationController
  def index
  end
  
  def map
  end
  
  def tester
    @response = TimeParse.parse(params[:time_input]) 
    @search_response = Home.search('l')
    # debugger
    respond_to do |format|
      format.html
      format.json {
        render :json => @search_response.to_json
      }
    end
  end
end
