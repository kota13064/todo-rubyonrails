require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  subject(:json) do
    JSON.parse(response.body)
  end

  describe 'GET /index' do
    let!(:tag1) { create(:tag) }
    let!(:tag2) { create(:tag) }
    let!(:tag3) { create(:tag) }

    it 'リクエストがステータスコード200で成功すること' do
      get tags_path
      expect(response).to have_http_status :ok
    end

    context '検索条件なし' do
      it do
        get tags_path
        expect(json).to eq [tag3.slice(:id, :name), tag2.slice(:id, :name), tag1.slice(:id, :name)]
      end
    end

    context '検索条件あり' do
      it do
        get tags_path, params: { name: tag1.name }
        expect(json).to include(tag1.slice(:id, :name))
      end
    end
  end

  describe '#create' do
    context '正常パラメータを送信したとき' do
      let!(:tag) { attributes_for(:tag) }

      it 'Tagのレコードがひとつ増えること' do
        expect do
          post tags_path, params: { tag: }
        end.to change(Tag, :count).by(1)
      end

      it 'リクエストがjsonで帰ってくること' do
        post tags_path, params: { tag: }
        expect(json).to include({ 'name' => tag[:name] })
      end
    end

    context '異常パラメータを送信したとき' do
      let!(:tag1) { create(:tag) }

      it 'nameが空白の時、エラーメッセージ' do
        post tags_path, params: { tag: attributes_for(:tag, name: nil) }
        expect(response).to have_http_status :unprocessable_entity
        expect(json['errors']).to include('タグ名を入力してください')
      end

      it 'nameが重複した時、エラーメッセージ' do
        post tags_path, params: { tag: attributes_for(:tag, name: tag1.name) }
        expect(response).to have_http_status :unprocessable_entity
        expect(json['errors']).to include('タグ名はすでに存在します')
      end
    end
  end
end
