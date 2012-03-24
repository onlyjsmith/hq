class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end
  
  def camps_index
    session[:company_id] = params[:id]
    redirect_to camps_path
  end
end
