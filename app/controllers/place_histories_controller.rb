# frozen_string_literal: true

class PlaceHistoriesController < PlacesController
  before_action :authenticate_user!
  before_action :set_place, only: [:create]

  def index
    place_ids = current_user.place_histories.pluck(:place_id)
    @places = filter_places(Place.where(id: place_ids)).page(params[:page]).per(10)
    @place_histories = current_user.place_histories.where(place_id: @places.pluck(:id)).includes(:place).order(created_at: :desc)
  end

  def create
    @place_history = current_user.place_histories.build(place: @place)
    destination = params[:destination]

    @place_history.save
    render json: { redirect_to: destination }
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end
end
