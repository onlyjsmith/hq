class Camp < ActiveRecord::Base 
  belongs_to :company
  belongs_to :location
  has_many :sightings
  
  # default_scope where(:company_id => session[:company_id])
      
  def self.company_camps(company)
    if company
      Camp.where(:company_id => company.id)
    else
      all
    end
  end
end
