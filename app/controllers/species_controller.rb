class SpeciesController < ApplicationController
  def index
    @species = Species.all
  end

  def show
    @species = Species.find(params[:id])
    @sightings = Sighting.where(:species_id => @species.id)
  end

  def edit
    @species = Species.find(params[:id])
  end

  def new
    @species = Species.new
  end

  def create
    @species = Species.new(params[:species])

    respond_to do |wants|
      if @species.save
        flash[:notice] = 'Species was successfully created.'
        wants.html { redirect_to(@species) }
        wants.xml { render :xml => @species, :status => :created, :location => @species }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @species.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @species = Species.find(params[:id])

    respond_to do |format|
      if @species.update_attributes(params[:species])
        format.html { redirect_to @species, notice: 'Species was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
  end
end
