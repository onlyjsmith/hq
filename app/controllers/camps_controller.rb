class CampsController < ApplicationController
  def index
    @camps = Camp.all
  end
end
