class TribesController < ApplicationController
  def index
    @tribes = Tribe.all
  end

  def show
    @tribe = Tribe.find(params[:id])
  end

  def edit
    @tribe = Tribe.find(params[:id])
  end

  def new
    @tribe = Tribe.new
  end

  def create
  end

  def update
  end

  def destroy
  end
end
