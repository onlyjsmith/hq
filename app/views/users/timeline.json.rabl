object @user => :timeline
node(:headline){|x| "#{@user.first_name}'s sightings"}
node(:type){|x| "default"}
node('startDate'){|x| @sightings.first.record_time.year}
node(:text){|x| "This is what you can do"}
child @sightings => :date do
  node 'startDate' do |s|
    d = s.record_time
    "#{d.year},#{d.month},#{d.day}"
  end
  attribute :description
  node :text do |s|
    "You saw a #{s.species.common_name} (#{s.species.binomial.downcase}). Well done you."
  end
end


