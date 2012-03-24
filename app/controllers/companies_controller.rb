class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end
  
  def show
    @company = Company.find(params[:id])
    # session[:company_id] = @company.id
    # redirect_to companies_path
  end
  
  def camps_index
    # session[:company_id] = params[:id]
    # session[:camp_id] = nil
    # redirect_to camps_path
  end
end
