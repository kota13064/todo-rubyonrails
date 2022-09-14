require 'rails_helper'

RSpec.describe TaskStatus, type: :model do
  context '正常パラメータを送信したとき' do
    it 'バリデーションに引っかからないこと' do
      task_status = build(:task_status)
      expect(task_status).to be_valid
    end
  end

  context '異常パラメータを送信したとき' do
    it 'nameがないとエラーが表示されること' do
      task_status = build(:task_status, name: nil)
      task_status.valid?
      expect(task_status.errors[:name]).to include('を入力してください')
    end
  end
end
