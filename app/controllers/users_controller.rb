class UsersController < ApplicationController
  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @events = @user.events.page(params[:page]).per(6)
    @tasks = @user.tasks.page(params[:page]).per(6)
    if params[:checked].present?
      # binding.pry
      notification = Notification.find_by!(visited_id: current_user.id, visiter_id: @user.id, action: "follow") #ここでNotificationモデルから左記の3つの情報を元に誰からの通知なのかを特定する。
      notification.update!(checked: true)
    end
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |current_user|
        @userEntry.each do |user|
          if current_user.room_id == user.room_id then
            @isRoom = true
            @roomId = current_user.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    # ログインしているユーザーがログインユーザー以外の編集ページにURLから直接遷移出来ないようにする。
    if @user != current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end
end
