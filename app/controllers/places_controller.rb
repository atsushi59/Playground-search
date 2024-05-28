# frozen_string_literal: true

class PlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity_type_options, only: [:index]

  def index
    @places = filter_places(current_user.places)
  end

  private

  def set_activity_type_options
    @activity_type_options = Place.distinct.pluck(:activity_type).compact
  end

  def filter_places(places)
    places = filter_by_address(places) if params[:address_cont].present?
    places = filter_by_activity_type(places) if params[:activity_type_eq].present?
    places = filter_by_keyword(places) if params[:keyword].present?
    places.order(id: :desc).page(params[:page]).per(10)
  end

  def filter_by_address(places)
    places.where('address LIKE ?', "%#{params[:address_cont]}%")
  end

  def filter_by_activity_type(places)
    places.where('activity_type = ?', params[:activity_type_eq])
  end

  def filter_by_keyword(places)
    keyword = "%#{params[:keyword]}%"
    places.where('name LIKE ? OR address LIKE ?', keyword, keyword)
  end

  def places_params
    params.require(:place).permit(:name, :address, :website, :opening_hours, :photo_url, :activity_type, :free_text)
  end
end
