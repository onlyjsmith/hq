node(:timeline){|x|}
child @user => :timeline do 
  node(:headline){|x| "#{@user.first_name}'s sightings"}
  node(:type){|x| "default"}
  node('startDate'){|x| @sightings.first.record_time.year.to_s}
  node(:text){|x| "This is what you can do"}
  child @sightings => :date do 
    node 'startDate' do |sighting|
      d = sighting.record_time
      "#{d.year},#{d.month},#{d.day}"
    end
    # attribute :description => :headline
    node :headline do |sighting|
      "#{sighting.species.common_name}"
    end
    node :text do |sighting|
      "You saw a #{sighting.species.common_name} (#{sighting.species.binomial.downcase}). Well done you."
      "By the way, it was at #{sighting.location.name} - and we can map that..."
    end

    child(:species => :asset) do |asset|
      node(:media, :if => lambda { |asset| asset.photos.count != 0 }) do |spp|
        spp.photos.first.url
        # sighting.species.photos.first.url
      end
    end
  end
end

