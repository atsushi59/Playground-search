class PlacesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @places = current_user.places
  end

end
