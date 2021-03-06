class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(join_room_params)
    redirect_to room_path(@room.id)
  end

  def index
    # ログインユーザーに紐付いたエントリーを取得する。
    @current_entries = current_user.entries.includes(:room)
    # ログインユーザーが属しているRoomのidを格納するための空配列を生成。
    myroom_ids = []
    # each文を使ってログインユーザーのRoomのidを配列に格納する。
    @current_entries.each do |entry|
      myroom_ids << entry.room.id
    end
    # Entryテーブルのログインユーザーが入っているroomのidとログインユーザーではない他ユーザーのuser_idをanotherEntriesに格納する。
    @anotherEntries = Entry.includes(:room, :user).where(room_id: myroom_ids).where('user_id != ?',@user.id).page(params[:page])
  end

  def show
    @room = Room.find(params[:id])
    opponent_users = Entry.where.not(user_id: current_user.id).where(room_id: @room.id)
    @opponent_user = opponent_users.first.user
    if (current_user.following?(@opponent_user)) && (@opponent_user.following?(current_user))
      if Entry.where(user_id: current_user.id, room_id: @room.id).present?
        @messages = @room.messages.includes(:user)
        @message = Message.new
        @entries = @room.entries.includes(:user).where.not(user_id: current_user.id)
        if params[:checked].present?
        notifications = @room.notifications.where!(visited_id: current_user.id)
        notifications.update(checked: true)
        end
      else
        redirect_back(fallback_location: users_path)
      end
    else
      redirect_to user_path(@opponent_user)
    end
  end

  private

  def join_room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end
end
