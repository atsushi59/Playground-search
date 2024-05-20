class ReviewsController < ApplicationController
    before_action :set_place, only: [:new, :create, :edit, :update]
    before_action :set_review, only: [:edit, :update, :destroy]

    def index
        @reviews = Review.includes(:user).order(created_at: :desc)
    end
    
    def new
        @review = @place.reviews.new
    end

    def create
        @review = @place.reviews.new(review_params)
        @review.user = current_user
    
        if @review.save
            redirect_to reviews_path, notice: 'レビューが投稿されました'
        else
            render :new, alert: 'レビューの投稿に失敗しました'
        end
    end

    def edit
    end

    def update
        if @review.update(review_params)
            redirect_to reviews_path, notice: 'レビューが更新されました'
        else
            render :edit, alert: 'レビューの更新に失敗しました'
        end
    end

    def destroy
        @review.destroy
        redirect_to reviews_path, notice: 'レビューが削除されました'
    end

    private

    def set_place
        @place = Place.find(params[:place_id])
    end

    def set_review
        @review = Review.find(params[:id])
    end

    def review_params
        params.require(:review).permit(:body, :rating)
    end
end
