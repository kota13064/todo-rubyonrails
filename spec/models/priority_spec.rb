require 'rails_helper'

RSpec.describe Priority, type: :model do
  context '正常パラメータを送信したとき' do
    it 'バリデーションに引っかからないこと' do
      priority = build(:priority, :high)
      expect(priority).to be_valid
    end
  end

  context '異常パラメータを送信したとき' do
    it 'nameがないとエラーが表示されること' do
      priority = build(:priority, :high, name: nil)
      priority.valid?
      expect(priority.errors[:name]).to include('を入力してください')
    end
  end
end
