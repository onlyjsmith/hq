class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end
  
  def camps_index
    # debugger
    session[:company_id] = params[:id]
    # debugger
    session[:camp_id] = nil
    redirect_to camps_path
  end
end
