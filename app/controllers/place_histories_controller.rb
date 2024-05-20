class PlaceHistoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_place, only: [:create]

    def index
        @activity_type_options = Place.distinct.pluck(:activity_type).compact
        @place_histories = current_user.place_histories.includes(:place).order(created_at: :desc).page(params[:page]).per(10)
    
        if params[:address_cont].present? || params[:activity_type_eq].present? || params[:keyword].present?
            @place_histories = @place_histories.joins(:place).where("places.address LIKE ?", "%#{params[:address_cont]}%") if params[:address_cont].present?
            @place_histories = @place_histories.joins(:place).where("places.activity_type = ?", params[:activity_type_eq]) if params[:activity_type_eq].present?
            if params[:keyword].present?
                keyword = "%#{params[:keyword]}%"
                @place_histories = @place_histories.joins(:place).where("places.name LIKE ? OR places.address LIKE ?", keyword, keyword)
            end
        end
    end

    def create
        @place_history = current_user.place_histories.build(place: @place)
        destination = params[:destination] || root_path

        @place_history.save
        render json: { redirect_to: destination }
    end

    private

    def set_place
        @place = Place.find(params[:place_id])
    end
end