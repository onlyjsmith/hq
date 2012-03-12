class TimeParse
  def self.parse(input)
    unless input.blank?
      abbr = {'wk'=>'week','wks' => 'week','w' => 'week','h' => 'hour','hr' => 'hour','hrs' => 'hour','d' => 'day', 'td' => 'today', 'yest' => 'yesterday', 'yes' => 'yesterday', 'ystr' => 'yesterday'}
      # Checks for '2d' or similar
      input_scan = input.scan(/[0-9]+[d,w,h,m,y]/)
      if input_scan.count == 0
        input_scan = input
      else
        # swaps '2d' for '2 d'
        input_scan = input.sub(input_scan[0], (input_scan[0].scan(/\d+|[a-zA-Z]+/).join(" ")))
      end

      # expands abbreviations
      input_scan = input_scan.split(' ').map{|x| abbr[x].nil? ? x : abbr[x]}.join(' ')
      
      parsed = Chronic.parse input_scan

      return "Input of #{input} --> converted to #{parsed}"
      
    else
      "No input yet"
    end
  end
end