require 'rails_helper'

RSpec.describe Tag, type: :model do
  context '正常パラメータを送信したとき' do
    it 'バリデーションに引っかからないこと' do
      tag = build(:tag)
      expect(tag).to be_valid
    end
  end

  context '異常パラメータを送信したとき' do
    it 'nameがないとエラーが表示されること' do
      tag = build(:tag, name: nil)
      tag.valid?
      expect(tag.errors[:name]).to include('を入力してください')
    end
  end
end
