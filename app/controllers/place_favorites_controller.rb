# frozen_string_literal: true

class PlaceFavoritesController < PlacesController
  before_action :authenticate_user!
  before_action :set_place, only: %i[create destroy]
  before_action :set_favorite, only: [:destroy]

  def index
    favorite_place_ids = current_user.places_favorites.pluck(:place_id)
    @places = filter_places(Place.where(id: favorite_place_ids))
  end

  def create
    @favorite = @place.places_favorites.new(user: current_user)
    @favorite.save
    render turbo_stream: turbo_stream.replace("favorite-button-#{@place.id}", partial: 'shared/favorite_button', locals: { place: @place })
  end

  def destroy
    @favorite = @place.places_favorites.find_by(user: current_user)
    @favorite.destroy
    render turbo_stream: turbo_stream.replace("favorite-button-#{@place.id}", partial: 'shared/favorite_button', locals: { place: @place })
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_favorite
    @favorite = current_user.places_favorites.find(params[:id])
  end
end
