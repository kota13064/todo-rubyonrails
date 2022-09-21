require 'rails_helper'

RSpec.describe User, type: :model do
  context '正常パラメータを送信したとき' do
    it 'バリデーションに引っかからないこと' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context '異常パラメータを送信したとき' do
    subject(:errors) do
      user.valid?
      user.errors
    end

    context 'emailがないとエラーが表示されること' do
      let(:user) { build(:user, email: nil) }

      it { expect(errors[:email]).to include('を入力してください') }
    end

    context 'emailの形式が正しくない(@がない)とエラーが表示されること' do
      let(:user) { build(:user, email: 'abcdefg') }

      it { expect(errors[:email]).to include('は不正な値です') }
    end

    context 'emailが既に登録されているとエラーが表示されること' do
      let!(:default_user) { create(:user) }
      let(:user) { build(:user, email: default_user.email) }

      it { expect(errors[:email]).to include('はすでに存在します') }
    end

    context 'passwordがないとエラーが表示されること' do
      let(:user) { build(:user, password: nil) }

      it { expect(errors[:password]).to include('を入力してください') }
    end

    context 'passwordが6文字未満だとエラーが表示されること' do
      let(:user) { build(:user, password: 'abcde') }

      it { expect(errors[:password]).to include('は6文字以上で入力してください') }
    end
  end
end
