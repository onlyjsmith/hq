class CampsController < ApplicationController
  def index
    # debugger
    @company = Company.find(params[:company_id])
    @camps = Camp.all
  end
end
