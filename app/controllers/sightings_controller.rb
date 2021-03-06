class SightingsController < ApplicationController
  autocomplete :species, :common_name, :full => true
  autocomplete :species, :binomial, :full => true
  autocomplete :tribe, :name, :full => true
  autocomplete :camp, :name, :full => true
  autocomplete :location, :name, :full => true
  
  def index

    @q = Sighting.search(params[:q]) 
    @sightings = @q.result(:distinct => true).paginate(:page => params[:page])

    # @drive_count = @sightings.map{|x| x.drive}.uniq.count
    # @species = @sightings.map{|x| x.species}.uniq
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sightings }
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
    @camp_location = Camp.first.location_point
    @species = Species.paginate(:page => params[:page], :per_page => 20)
    
    @q = Sighting.search(params[:q]) 
    @sightings = @q.result(:distinct => true)
    
    @sighting = Sighting.new(params[:details])
    respond_to do |format|
      format.html
      format.json {render json: @camp_location['coordinates']}
    end
  end
  
  def create
    @sighting = Sighting.new

    # TODO: Change these defaults - they're just for demo purpose
    # TODO: Definitely want to add defaults and validations to the model, not controller
    @sighting.species_id = params[:species_id]
    @sighting.tribe_id = params[:tribe_id]
    @sighting.location_id = params[:location_id] ||
    
    # Time has a weird _id suffix - it's just to keep the JS simple
    # TODO: Put the parsing of time back in
    # @sighting.record_time = Time.parse(params[:time_id]) || Time.now    
    @sighting.record_time =  Time.now
    @sighting.time_window_hr = 0
    @sighting.description = params[:description] || "No description"
    @sighting.camp_id = 1
    @sighting.drive_id = 1
    @sighting.submission_point = "HQ"
    @sighting.user_id = 1
    
    # debugger
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

  def download
    sightings = Sighting.all
    csv_string = CSV.generate do |csv| 
      # TODO - move this 'view' stuff out of controller
      csv << %w(When CommonName Binomial Camp LocationName UserEmail)
      sightings.each do |s|
        # debugger
        csv << [s.record_time, s.species.common_name, s.species.binomial, s.camp.name, s.location.name, s.user.email]
      end
    end
    send_data csv_string, :type => "text/plain", 
     :filename=>"sightings.csv",
     :disposition => 'attachment'
  end

  def headlines
    @sightings = Sighting.all
  end
  
  def digitise
    # debugger
    @sighting = Sighting.new
    @species = Species.all.select{|x| x if x.photos.count != 0}
  end
  
  # def filter
  #   @q = Sighting.search(params[:q]) 
  #   @sightings = @q.result(:distinct => true)
  # 
  #   # respond_to do |format|
  #   #   format.html # index.html.erb
  #   #   format.json { render json: @sightings }
  #   #   format.js
  #   # end
  #   redirect_to :index
  # end          
end
