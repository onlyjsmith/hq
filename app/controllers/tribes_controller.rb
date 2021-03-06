class TribesController < ApplicationController
  def index
    @tribes = Tribe.all
    # @tribes = @tribes.by_species(params[:species_id]) if params[:species_id]
    # @species = Species.find(params[:species_id]) if params[:species_id]
  end

  def show
    @tribe = Tribe.find(params[:id])
    @sightings = Sighting.where(:tribe_id => @tribe.id)
  end

  def edit
    @tribe = Tribe.find(params[:id])
  end

  def new
    # debugger
    @species = Species.find(params[:species_id])
    @tribe = Tribe.new
    @tribe.species_id = @species.id
  end

  def create
    @tribe = Tribe.new(params[:tribe])
  
    respond_to do |wants|
      if @tribe.save
        flash[:notice] = 'Tribe was successfully created.'
        wants.html { redirect_to(@tribe) }
        wants.xml { render :xml => @tribe, :status => :created, :location => @tribe }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @tribe.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @tribe = Tribe.find(params[:id])

    respond_to do |format|
      if @tribe.update_attributes(params[:tribe])
        format.html { redirect_to @tribe, notice: 'Tribe was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
  end
end
