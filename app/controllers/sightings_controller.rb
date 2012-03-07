class SightingsController < ApplicationController
  def index
    @user = "Bob"
    @camp = Camp.first
    @drive_count = Drive.count
    @sightings = Sighting.all
    
    @h = LazyHighCharts::HighChart.new('graph') do |f|
        f.options[:chart][:defaultSeriesType] = "area"
        # f.options[:chart][:height] = "200px"
        # f.options[:chart][:width] = "100px"
        f.options[:title][:text] = nil
        f.series(:name=>'Lion', :color => '#b1ad73', :data=>[3, 20, 3, 5, 4, 10, 12, 5,6,7,7,10,9,9])
        f.series(:name=>'Tiger', :color => '#6b8665', :data=> [1, 3, 4, 3, 3, 5, 4,7,8,8,9,9,0,0,9] )
      end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sightings }
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

  def edit
  end
end
