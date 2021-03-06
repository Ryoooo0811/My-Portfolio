class NotificationsController < ApplicationController
  def index
    # current_userの投稿に紐づいた通知一覧
    @notifications = current_user.passive_notifications.select(:visiter_id, :event_id, :task_id, :room_id).distinct.page(params[:page])
    # @notificationの中でまだ確認していない(indexに一度も遷移していない)通知のみ
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def destroy
    @notification = current_user.passive_notifications.find_by(params[checked: false])
    @notification.destroy
    redirect_to request.referer
  end

  def destroy_all
    # 通知を全削除
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to request.referer
  end
end
