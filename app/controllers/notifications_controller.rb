class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications_as_visited.order(created_at: :desc).page(params[:page]).per(10)
    @notifications.where(read: false).each do |notification|
      notification.update(read: true)
    end
  end
end
