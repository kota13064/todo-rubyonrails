require 'rails_helper'

RSpec.describe TaskTag, type: :model do
  before do
    create(:task_status, :todo)
    create(:priority, :high)
  end

  let!(:task) { create(:task) }
  let!(:tag) { create(:tag) }

  context '正常パラメータを送信したとき' do
    it 'バリデーションに引っかからないこと' do
      task_tag = build(:task_tag, task:, tag:)
      expect(task_tag).to be_valid
    end
  end

  context '異常パラメータを送信したとき' do
    it 'tag_idがないとエラーが表示されること' do
      task_tag = build(:task_tag, task:, tag_id: nil)
      task_tag.valid?
      expect(task_tag.errors[:tag]).to include('を入力してください')
    end

    it 'task_idがないとエラーが表示されること' do
      task_tag = build(:task_tag, task_id: nil, tag:)
      task_tag.valid?
      expect(task_tag.errors[:task]).to include('を入力してください')
    end
  end
end
