# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :set_place
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @review.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to place_review_path(@place, @review), notice: 'コメントが投稿されました'
    else
      redirect_to place_review_path(@place, @review), alert: 'コメントの投稿に失敗しました'
    end
  end

  def destroy
    @comment.destroy
    redirect_to place_review_path(@place, @review), notice: 'コメントが削除されました'
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end

  def set_place
    @place = @review.place
  end

  def set_comment
    @comment = @review.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
