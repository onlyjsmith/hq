class Home
# Made this class to test out the multi-model autocompleter

  def self.search(term)
    @models = {:species => :common_name,:tribe => :name,:location => :name}
    response = []
    @models.each do |model, column|
      eval("#{model.capitalize}").where("#{column} ILIKE ?","%#{term}%").each do |result|
        result_hash = {:label => result.send(column)}
        response.push result_hash
      end
    end
    # debugger
    response
  end

end