class Camp < ActiveRecord::Base 
  belongs_to :company
  belongs_to :location
  has_many :sightings
      
  # def self.company_camps(company_id)
  #   Camp.where(:company_id => company_id)
  # end
end
