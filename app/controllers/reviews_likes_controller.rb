# frozen_string_literal: true

class ReviewsLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    @review_like = @review.reviews_likes.new(user: current_user)
    @review_like.save
    @like_count = @review.reviews_likes.count
    render turbo_stream: turbo_stream.replace("like-button-#{@review.id}", partial: 'reviews/like_button', locals: { review: @review, place: @review.place, like_count: @like_count })
  end

  def destroy
    @review_like = @review.reviews_likes.find_by(user: current_user)
    @review_like.destroy
    @like_count = @review.reviews_likes.count
    render turbo_stream: turbo_stream.replace("like-button-#{@review.id}", partial: 'reviews/like_button', locals: { review: @review, place: @review.place, like_count: @like_count })
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end
end
