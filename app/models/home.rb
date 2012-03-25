class Home
# Made this class to test out the multi-model autocompleter

  def self.search(term)
    @model_names = {'species' => 'common_name','tribe' => 'name','location' => 'name',}
    response = []
    @model_names.each do |model_name, column|
      eval("#{model_name.capitalize}").where("#{column} ILIKE ?","%#{term}%").each do |result|
        # debugger
        result_hash = {:label => result.send(column), :value => result.id, :category => model_name}
        response.push result_hash
      end
    end
    time_hash = {:label => "#{(TimeParse.parse(term))}", :value => "#{(TimeParse.parse(term))}", :category => 'time'}
    response.push time_hash
    # debugger
    response
  end

end