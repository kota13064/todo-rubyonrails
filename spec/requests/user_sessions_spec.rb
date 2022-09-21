require 'rails_helper'

RSpec.describe 'UserSessions', type: :request do
  describe 'GET /index' do
    it 'リクエストがステータスコード200で成功すること' do
      get '/login'
      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /create' do
    subject(:post_response) do
      post login_path, params: { email: user.email, password: user.password }
      response
    end

    let!(:user) { create(:user) }

    it 'リクエストが成功してステータスコード302でリダイレクトすること' do
      expect(post_response).to redirect_to tasks_path
    end

    it 'session[:user_id]とユーザーのidが一致すること' do
      post_response
      expect(session[:user_id]).to eq user.id
    end
  end

  describe 'POST /destroy' do
    subject(:delete_response) do
      post login_path, params: { email: user.email, password: user.password }
      delete logout_path
      response
    end

    let!(:user) { create(:user) }

    it 'ログアウトが成功すること' do
      expect(delete_response).to redirect_to login_path
    end

    it 'session[:user_id]の中身が空であること' do
      delete_response
      expect(session[:user_id]).to be_nil
    end
  end
end
