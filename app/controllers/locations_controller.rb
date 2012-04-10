class LocationsController < ApplicationController
  
  def index
    @locations = Location.all
  end
  
  def new
    @location = Location.new
  end
  
  def create
    # debugger
    if params[:location]
      @location = Location.new(params[:location])
    elsif params[:coords]
      @location = Location.create_from_point(params['coords'])
    end
    
    respond_to do |wants|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        wants.html { redirect_to(@location) }
        wants.json { render json: @location }
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
  
  def search
    if params[:bounding_box]
      locations = Location.search_by_bounding_box(params[:bounding_box])
    elsif params[:coords]
      locations = Location.find_by_coords(params[:coords])
    # else
    #   locations = Location.all.map{|x| {:value => x.name, :label => x.id}}
    end
    respond_to do |format|
      format.json { render json: locations}
    end
  end
  
end
