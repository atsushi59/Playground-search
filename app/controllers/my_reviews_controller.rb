class MyReviewsController < ReviewsController
  before_action :authenticate_user!

  def index
    @my_reviews = current_user.reviews.includes(:place).order(created_at: :desc)
    @my_reviews = filter_reviews(@my_reviews).page(params[:page]).per(12)
  end
end