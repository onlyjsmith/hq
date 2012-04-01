class Sighting < ActiveRecord::Base
  belongs_to :species
  belongs_to :tribe
  belongs_to :user
  belongs_to :drive
  belongs_to :location
  belongs_to :camp

  validates :species_id, :presence => true
  validates :location_id, :presence => true
  validates :description, :presence => true
  validates :user_id, :presence => true
  validates :record_time, :presence => true

  after_initialize :default_values
  
  private
  
  def default_values
    self.record_time ||= Time.now
    self.submission_point ||= "HQ"
    self.time_window_hr ||= 4
  end

end
