class Species < ActiveRecord::Base
  has_many :sightings
  has_many :tribes
  
  def first_photo_url
    # TODO - Probably want to do this as a task and populate a DB instead, but this works!
    FlickRaw.api_key = APP_CONFIG['FlickRaw_api_key']
    FlickRaw.shared_secret = APP_CONFIG['FlickRaw_shared_secret']
    # debugger
    # puts "self #{self.common_name}"
    # 
    # puts "Flickr shared secret"
    # puts APP_CONFIG['FlickRaw_shared_secret']
    photo_url = ""
    results = flickr.photos.search(:text => common_name, 
      :license => '1,2,3,4,5,6,7', 
      :privacy_filter => "1", 
      :sort => "interestingness-desc",
      :per_page => 10, 
      :extras => "url_s")
    results.each do |photo|
      # debugger
      if photo.respond_to?(:url_s) && photo.url_s
        photo_url = photo.url_s
        break
      end
    end
    photo_url
  end
end
