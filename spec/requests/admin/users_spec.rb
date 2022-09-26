require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:admin_user) { create(:user, :admin) }

  # 管理者権限ユーザーでログイン
  before do
    post login_path, params: { email: admin_user.email, password: admin_user.password }
  end

  describe '#index' do
    it 'リクエストがステータスコード200で成功すること' do
      get admin_users_url
      expect(response).to have_http_status :ok
    end
  end

  describe '#show' do
    subject(:get_response) do
      get admin_user_url user
      response
    end

    context 'リクエストしたユーザーが存在しているとき' do
      let!(:user) { create(:user) }

      it 'リクエストがステータスコード200で成功すること' do
        expect(get_response).to have_http_status :ok
      end

      it 'レスポンスにユーザー名が含まれていること' do
        expect(get_response.body).to include user.name
      end

      it 'レスポンスにメールアドレスが含まれていること' do
        expect(get_response.body).to include user.email
      end

      it 'レスポンスにタスク数が含まれていること' do
        create(:task_status, :todo)
        create(:priority, :high)
        create_list(:task, rand(3..10), user:)
        expect(get_response.body).to include user.tasks.size.to_s
      end
    end

    context 'リクエストしたユーザーが存在しないとき' do
      it 'リクエストがステータスコード404で失敗すること' do
        get admin_user_path 1
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#new' do
    it 'リクエストがステータスコード200で成功すること' do
      get new_admin_user_path
      expect(response).to have_http_status :ok
    end
  end

  describe '#edit' do
    let!(:user) { create(:user) }

    it 'リクエストがステータスコード200で成功すること' do
      get edit_admin_user_path user
      expect(response).to have_http_status :ok
    end
  end

  describe '#create' do
    context '正常パラメータ' do
      subject(:post_response) do
        post admin_users_path, params: { user: attributes_for(:user) }
        response
      end

      it 'Userのレコードがひとつ増えること' do
        expect do
          post admin_users_url, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'リクエストがステータスコード302でリダイレクトすること' do
        expect(post_response).to have_http_status :found
      end

      it 'リクエストが作ったユーザーのページにリダイレクトすること' do
        expect(post_response).to redirect_to admin_user_path User.last
      end
    end

    context '異常パラメータ' do
      subject(:post_response) do
        post admin_users_path, params: { user: attributes_for(:user, password: nil) }
        response
      end

      it '新しくユーザーが作られないこと' do
        expect do
          post admin_users_path, params: { user: attributes_for(:user, password: nil) }
        end.not_to change(User, :count)
      end

      it 'リクエストがステータスコード422で失敗すること' do
        post admin_users_path, params: { user: attributes_for(:user, password: nil) }
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe '#update' do
    let!(:user) { create(:user) }

    context '正常パラメータ' do
      subject(:put_response) do
        put admin_user_path user, params: { user: attributes_for(:user, name: 'update name', email: 'update_email@test.com') }
        response
      end

      it 'リクエストがステータスコード302でリダイレクトすること' do
        expect(put_response).to have_http_status :found
      end

      it 'リクエストが編集したユーザーのページにリダイレクトすること' do
        expect(put_response).to redirect_to admin_user_path User.last
      end
    end

    context '異常パラメータ' do
      it 'リクエストがステータスコード422で失敗すること' do
        put admin_user_path user, params: { user: attributes_for(:user, email: nil) }
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe '#destroy' do
    subject(:delete_response) do
      delete admin_user_path user
      response
    end

    let!(:user) { create(:user) }

    it 'ユーザーがひとつ減ること' do
      expect do
        delete admin_user_path user
      end.to change(User, :count).by(-1)
    end

    it 'リクエストがステータスコード302でリダイレクトすること' do
      expect(delete_response).to have_http_status :found
    end

    it 'リクエストがユーザー一覧ページにリダイレクトすること' do
      expect(delete_response).to redirect_to(admin_users_path)
    end
  end
end
