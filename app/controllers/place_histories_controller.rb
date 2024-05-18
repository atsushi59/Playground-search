class PlaceHistoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_place, only: [:create]

    def index
        @place_histories = current_user.place_histories.includes(:place).order(created_at: :desc).page(params[:page]).per(10)
    end

    def create
        @place_history = current_user.place_histories.build(place: @place)
        destination = params[:destination] || root_path

        if @place_history.new_record?
            @place_history.save
        end
        
        redirect_to destination, allow_other_host: true
    end

    private

    def set_place
        @place = Place.find(params[:place_id])
    end
end