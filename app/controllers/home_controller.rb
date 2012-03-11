class HomeController < ApplicationController
  def index
  end
  
  def map
  end
  
  def time
    @response = TimeParse.parse(params[:time_input])
  end
end
