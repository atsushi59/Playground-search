class PlaceFavoritesController < PlacesController
    
    before_action :authenticate_user!
    before_action :set_favorite, only: [:destroy]

    def index
        favorite_place_ids = current_user.places_favorites.pluck(:place_id)
        @places = filter_places(Place.where(id: favorite_place_ids))
    end

    def create
        @favorite = current_user.places_favorites.create(place: @place)
        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream_replace(@place) }
            format.html { redirect_to @place }
        end
    end

    def destroy
        @place = @favorite.place
        @favorite.destroy
        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream_replace(@place) }
            format.html { redirect_to @place }
        end
    end

    private

    def set_place
        @place = Place.find(params[:place_id])
    end

    def set_favorite
        @favorite = current_user.places_favorites.find(params[:id])
    end

    def turbo_stream_replace(place)
        turbo_stream.replace(dom_id(place, :favorite_button), partial: 'shared/favorite_button', locals: { place: place })
    end
end