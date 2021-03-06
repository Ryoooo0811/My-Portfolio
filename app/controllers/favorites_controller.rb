class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    favorite = current_user.favorites.new(event_id: @event.id)
    favorite.save
    # 通知の作成
    @event.create_notification_by(current_user)
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    favorite = current_user.favorites.find_by(event_id: @event.id)
    # 通知の削除
    @event.destroy_notification_by(current_user)
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end
    favorite.destroy
  end
end
