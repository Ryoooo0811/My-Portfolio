# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaskCommentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { task_comment.valid? }

    let!(:user) { create(:user) }
    let!(:task) { build(:task, user_id: user.id) }
    let!(:task_comment) { build(:task_comment, user_id: user.id) }
    let(:notification) { build(:notification, visiter_id: user.id, visited_id: user.id, task_id: task.id, task_comment_id: task_comment.id) }

    context 'commentカラム' do
      it '空欄でないこと' do
        task_comment.comment = ''
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1の関係になっている' do
        expect(TaskComment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Taskモデルとの関係' do
      it 'N:1の関係になっている' do
        expect(TaskComment.reflect_on_association(:task).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(TaskComment.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end