# frozen_string_literal: true

class MyReviewsController < ReviewsController
  before_action :authenticate_user!

  def index
    @my_reviews = Place.with_reviews_by_user(current_user.id).order('reviews.created_at DESC').page(params[:page]).per(12)
    @my_reviews = filter_reviews(@my_reviews)
  end
end
