class SightingsController < ApplicationController
  autocomplete :species, :common_name
  
  def index
    @user = "Bob"
    @camp = Camp.first
    @sightings = Sighting.search(params[:search])
    @drive_count = @sightings.map{|x| x.drive}.uniq.count

    @h = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:chart] = {:height => 200, :width => 400, :defaultSeriesType =>  "area" }
      f.options[:yAxis][:max] = 20
      f.options[:title][:text] = nil 
      f.options[:legend] = {:floating => true, :verticalAlign => 'top'}
      f.series(:name=>'Lion', :color => '#b1ad73', :data=>[3, 20, 3, 5, 4, 10, 12, 5,6,7,7,10,9,9])
      f.series(:name=>'Tiger', :color => '#6b8665', :data=> [1, 3, 4, 3, 3, 5, 4,7,8,8,9,9,0,0,9] )
    end
    
    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @sightings }
      format.js
    end
  end

  def show
    @sighting = Sighting.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.json { render json: @sighting}
    end
  end

  def new
    @sighting = Sighting.new
  end
  
  def create
    @sighting = Sighting.new(params[:sighting])
    
    respond_to do |wants|
      if @sighting.save
        flash[:notice] = 'Sighting was successfully created.'
        wants.html { redirect_to(@sighting) }
        wants.xml { render :xml => @sighting, :status => :created, :location => @sighting }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @sighting.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  def edit
    @sighting = Sighting.find(params[:id])
  end
  
  def update
    @sighting = Sighting.find(params[:id])

    respond_to do |format|
      if @sighting.update_attributes(params[:sighting])
        format.html { redirect_to @sighting, notice: 'Sighting was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def getcsv
    sightings = Sighting.all
    csv_string = CSV.generate do |csv| 
      # TODO - move this 'view' stuff out of controller
      csv << %w(When What Where)
      sightings.each do |s|
        csv << [s.record_time, s.species.common_name, s.location.name]
      end
    end
    send_data csv_string, :type => "text/plain", 
     :filename=>"sightings.csv",
     :disposition => 'attachment'
  end

  
  # def search
  #   puts params
  #   @sightings = Sighting.duration(params[:duration])
  #   respond_to do |format|
  #     format.html { render :partial => 'entries' }
  #     format.json { render json: @sightings }
  #   end
  # end
end
