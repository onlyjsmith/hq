class Species < ActiveRecord::Base
  has_many :sightings
  has_many :tribes 
  has_many :photos, :as => :imageable

  accepts_nested_attributes_for :tribes, :allow_destroy => true  
  
  def self.photoed
    all.select{|x| x if x.photos.count !=0}
  end
  
  def get_photo_url
    unless self.photos.blank?
      return self.photos.first.url
    end
    # debugger
    FlickRaw.api_key = APP_CONFIG['FlickRaw_api_key']
    FlickRaw.shared_secret = APP_CONFIG['FlickRaw_shared_secret']

    results = flickr.photos.search(:text => common_name, 
      :license => '1,2,3,4,5,6,7', 
      :privacy_filter => "1", 
      :sort => "interestingness-desc",
      :per_page => 1, 
      :extras => "url_s")
    unless results.blank?
      results.each do |result|
        if result.respond_to?(:url_s) && result.url_s
#          debugger 
          photo = self.photos.create(:url => result.url_s)
          break
        end
      end
    # return self.photos.first.url
    end
  end
  
  def get_better_photo
    break_count = rand(15)
    FlickRaw.api_key = APP_CONFIG['FlickRaw_api_key']
    FlickRaw.shared_secret = APP_CONFIG['FlickRaw_shared_secret']

    results = flickr.photos.search(:text => common_name, 
      :license => '1,2,3,4,5,6,7', 
      :privacy_filter => "1", 
      :sort => "interestingness-desc",
      :per_page => 15, 
      :extras => "url_s")
    results.each_with_index do |result,index|
      if result.respond_to?(:url_s) && result.url_s
        @photo_url = result.url_s
        break if index == break_count
      end
    end
    self.photos.destroy_all
    self.photos.create(:url => @photo_url)
    puts "Replaced photo for #{self.common_name}"
  end
end
