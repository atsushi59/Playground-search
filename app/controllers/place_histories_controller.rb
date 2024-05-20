class PlaceHistoriesController < PlacesController
    before_action :set_place, only: [:create]

    def index
        place_ids = current_user.place_histories.pluck(:place_id)
        @places = filter_places(Place.where(id: place_ids))
        filtered_place_ids = @places.pluck(:id)
        @place_histories = current_user.place_histories.where(place_id: filtered_place_ids).includes(:place).order(created_at: :desc).page(params[:page]).per(10)
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
