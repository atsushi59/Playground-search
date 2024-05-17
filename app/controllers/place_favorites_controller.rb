class PlaceFavoritesController < PlacesController
    include ActionView::RecordIdentifier
    
    before_action :set_place, only: [:create]
    before_action :set_favorite, only: [:destroy]

    def index
        favorite_place_ids = current_user.places_favorites.pluck(:place_id)
        @places = Place.where(id: favorite_place_ids)
    
        if params[:address_cont].present? || params[:activity_type_eq].present? || params[:keyword].present?
            @places = @places.where("address LIKE ?", "%#{params[:address_cont]}%") if params[:address_cont].present?
            @places = @places.where("activity_type = ?", params[:activity_type_eq]) if params[:activity_type_eq].present?
            if params[:keyword].present?
            keyword = "%#{params[:keyword]}%"
            @places = @places.where("name LIKE ? OR address LIKE ?", keyword, keyword)
            end
        end
        @places = @places.order(id: :desc).page(params[:page]).per(10)
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