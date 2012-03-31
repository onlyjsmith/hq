class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp
  
  
  # def self.filter_by_params(params)
  #   models = %w(tribe species camp location)
  #   models.each do |m|
  #     if params.include?(m)
  #       # debugger
  #       method = "by_" + m.to_s
  #       value = params.fetch(m.to_sym)
  #       self.send method, value
  #     end
  #   end
  # end
  # 
  # def self.by_species(species_id)
  #   if species_id
  #     where(:species_id => species_id)
  #   else
  #     all
  #   end
  # end
  # 
  # def self.by_tribe(tribe_id)
  #   if tribe_id
  #     where(:tribe_id => tribe_id)
  #   else
  #     all
  #   end
  # end
  # 
  # def self.by_camp(camp_id)
  #   if camp_id
  #     where(:camp_id => camp_id)
  #   else
  #     all
  #   end
  # end
  # 
  # def self.by_time(filter_time)
  #   if filter_time
  #     where("record_time > ?", (Date.today - filter_time.to_i))
  #   else
  #     all
  #   end
  # end

end
