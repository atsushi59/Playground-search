class ReviewFavoritesController < ApplicationController
    before_action :set_review

    def create
        @review_favorite = @review.review_favorites.new(user: current_user) 
        @review_favorite.save
        render turbo_stream: turbo_stream.replace("favorite-button-#{@review.id}", partial: 'reviews/favorite_button', locals: { review: @review, place: @review.place })
    end    

    def destroy
        @review_favorite = @review.review_favorites.find_by(user: current_user)
        @review_favorite.destroy
        render turbo_stream: turbo_stream.replace("favorite-button-#{@review.id}", partial: 'reviews/favorite_button', locals: { review: @review, place: @review.place })
    end

    private

    def set_review
        @review = Review.find(params[:review_id])
    end
end
