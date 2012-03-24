class Camp < ActiveRecord::Base 
  belongs_to :company
  belongs_to :location
  has_many :sightings
  
  default_scope where(:company_id => session[:company_id])
      
  # def self.company_camps(company_id)
  #   Camp.where(:company_id => company_id)
  # end
end
