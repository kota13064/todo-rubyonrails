require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    create(:task_status, :todo)
    create(:priority, :high)
  end

  context '正常パラメータを送信したとき' do
    it 'バリデーションに引っかからないこと' do
      task = build(:task)
      expect(task).to be_valid
    end
  end

  context '異常パラメータを送信したとき' do
    it 'nameがないとエラーが表示されること' do
      task = build(:task, name: nil)
      task.valid?
      expect(task.errors[:name]).to include('を入力してください')
    end
  end
end
