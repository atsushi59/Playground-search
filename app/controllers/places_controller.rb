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
    if params[:address_cont].present? || params[:activity_type_eq].present? || params[:keyword].present?
      places = places.where("address LIKE ?", "%#{params[:address_cont]}%") if params[:address_cont].present?
      places = places.where("activity_type = ?", params[:activity_type_eq]) if params[:activity_type_eq].present?
      if params[:keyword].present?
        keyword = "%#{params[:keyword]}%"
        places = places.where("name LIKE ? OR address LIKE ?", keyword, keyword)
      end
    end
    places.order(id: :desc).page(params[:page]).per(10)
  end

  def places_params
    params.require(:place).permit(:name, :address, :website, :opening_hours, :photo_url, :activity_type, :free_text)
  end
end
