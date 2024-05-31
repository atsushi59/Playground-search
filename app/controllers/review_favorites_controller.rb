# frozen_string_literal: true

class ReviewFavoritesController < ReviewsController
  before_action :authenticate_user!
  before_action :set_review, only: %i[create destroy]

  def index
    @favorite_reviews = Review.joins(:review_favorites).where(review_favorites: { user_id: current_user.id }).includes(:place).order(created_at: :desc).page(params[:page]).per(12)
    @favorite_reviews = filter_reviews(@favorite_reviews)
  end

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

  def filter_reviews(reviews)
    reviews = filter_by_address(reviews)
    reviews = filter_by_activity_type(reviews)
    filter_by_keyword(reviews)
  end

  def filter_by_address(reviews)
    return reviews unless params[:address_cont].present?

    reviews.joins(:place).where('places.address LIKE ?', "%#{params[:address_cont]}%")
  end

  def filter_by_activity_type(reviews)
    return reviews unless params[:activity_type_eq].present?

    reviews.joins(:place).where('places.activity_type = ?', params[:activity_type_eq])
  end

  def filter_by_keyword(reviews)
    return reviews unless params[:keyword].present?

    keyword = "%#{params[:keyword]}%"
    reviews.joins(:place).where('places.name LIKE ? OR places.address LIKE ?', keyword, keyword)
  end
end
