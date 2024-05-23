class ReviewsController < ApplicationController
    before_action :set_place, only: [:new, :create, :edit, :update, :show]
    before_action :set_review, only: [:edit, :update, :destroy, :show]
    before_action :set_activity_type_options, only:[:index]
    before_action :set_prefecture_options, only: [:index]

    def index
        @reviews = filter_reviews(Review.includes(:user, :place).order(created_at: :desc)).page(params[:page]).per(12)
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
            flash.now[:alert] = 'レビューの投稿に失敗しました'
            render :new
        end
    end

    def show
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

    def set_activity_type_options
        @activity_type_options = Place.distinct.pluck(:activity_type).compact
    end

    def set_prefecture_options
        @prefecture_options = prefecture_options
    end

    def filter_reviews(reviews)
        if params[:address_cont].present? || params[:activity_type_eq].present? || params[:keyword].present?
            reviews = reviews.joins(:place)
            reviews = reviews.where("places.address LIKE ?", "%#{params[:address_cont]}%") if params[:address_cont].present?
            reviews = reviews.where("places.activity_type = ?", params[:activity_type_eq]) if params[:activity_type_eq].present?
            if params[:keyword].present?
                keyword = "%#{params[:keyword]}%"
                reviews = reviews.where("places.name LIKE ? OR places.address LIKE ?", keyword, keyword)
            end
        end
        reviews
    end
end
