# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_place, only: %i[new create edit update show]
  before_action :set_review, only: %i[edit update destroy show]
  before_action :set_activity_type_options, only: [:index]
  before_action :set_prefecture_options, only: [:index]

  def index
    @places_with_reviews = Place.joins(:reviews).includes(:reviews).distinct.order(created_at: :desc).page(params[:page]).per(12)
    @places_with_reviews = filter_reviews(@places_with_reviews)
    @average_ratings = calculate_average_ratings(@places_with_reviews)
    @reviews = @places_with_reviews.map(&:reviews).flatten
  end

  def new
    @review = @place.reviews.new
  end

  def create
    @review = @place.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to place_review_path(@place, @review), notice: 'レビューが投稿されました'
    else
      flash.now[:alert] = 'レビューの投稿に失敗しました'
      render :new
    end
  end

  def show
    @reviews = @place.reviews.order(created_at: :desc)
  end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to place_review_path(@place, @review), notice: 'レビューが更新されました'
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

  def calculate_average_ratings(places)
    average_ratings = {}
    places.each do |place|
      average_ratings[place.id] = place.reviews.average(:rating).to_f.round(2)
    end
    average_ratings
  end

  def filter_reviews(places)
    places = filter_by_address(places) if params[:address_cont].present?
    places = filter_by_activity_type(places) if params[:activity_type_eq].present?
    places = filter_by_keyword(places) if params[:keyword].present?
    places
  end

  def filter_by_address(places)
    places.where('places.address LIKE ?', "%#{params[:address_cont]}%")
  end

  def filter_by_activity_type(places)
    places.where('places.activity_type = ?', params[:activity_type_eq])
  end

  def filter_by_keyword(places)
    keyword = "%#{params[:keyword]}%"
    places.where('places.name LIKE ? OR places.address LIKE ?', keyword, keyword)
  end
end
