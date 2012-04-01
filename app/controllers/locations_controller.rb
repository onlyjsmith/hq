class LocationsController < ApplicationController
  
  def index
    @locations = Location.all
  end
  
  def new
    @location = Location.new
  end
  
  def create
    @location = Location.new(params[:location])
    # debugger
    respond_to do |wants|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        wants.html { redirect_to(@location) }
      else
        wants.html { render :action => "new" }
      end
    end
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
  def edit
    @location = Location.find(params[:id])
  end
  
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
  def post_polygon
    response = Location.store_poly_to_cartodb(params)
    respond_to do |format|
      format.json { render :json => {:cartodb_id => response}}
    end
  end
  
end
