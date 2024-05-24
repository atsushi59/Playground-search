# frozen_string_literal: true

class MyReviewsController < ReviewsController
  before_action :authenticate_user!

  def index
    @my_reviews = Place.joins(:reviews).includes(:reviews).distinct.order(created_at: :desc).page(params[:page]).per(12)
    @my_reviews = filter_reviews(@my_reviews)
  end
end
