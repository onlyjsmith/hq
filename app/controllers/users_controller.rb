class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @sightings = @user.sightings.paginate(:page => params[:page], :per_page => 10)
  end
  
  def timeline
    @user = User.find(params[:user_id])
    @sightings = @user.sightings
  end
end
