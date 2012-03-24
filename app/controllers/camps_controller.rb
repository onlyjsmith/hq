class CampsController < ApplicationController
  def index
    # debugger
    @company = Company.find(params[:company_id])
    @camps = Camp.all
    @sightings = @company.camps.map{|e| e.sightings}.flatten
  end
end
