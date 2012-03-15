class Species < ActiveRecord::Base
  has_many :sightings
  has_many :tribes 
  has_many :photos, :as => :imageable
  
  def get_photo_url
    # debugger
    unless self.photos.blank?
      return self.photos.first.url
    end
    # TODO - Probably want to do this as a task and populate a DB instead, but this works!
    FlickRaw.api_key = APP_CONFIG['FlickRaw_api_key']
    FlickRaw.shared_secret = APP_CONFIG['FlickRaw_shared_secret']

    results = flickr.photos.search(:text => common_name, 
      :license => '1,2,3,4,5,6,7', 
      :privacy_filter => "1", 
      :sort => "interestingness-desc",
      :per_page => 10, 
      :extras => "url_s")
    results.each do |result|
      if result.respond_to?(:url_s) && result.url_s
        # debugger
        photo = self.photos.create(:url => result.url_s)
        # self.photo_id = result.id
        # self.save
        puts photo
        break
      end
    end
    return self.photos.first.url
  end
end
