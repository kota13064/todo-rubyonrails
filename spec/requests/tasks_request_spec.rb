require 'rails_helper'

RSpec.describe TasksController, type: :request do
  describe '#index' do
    it 'リクエストがステータスコード200で成功すること' do
      get tasks_path
      expect(response).to have_http_status 200
    end

    context 'ソート条件なし' do
      let!(:task1) { create(:task, created_at: Time.zone.tomorrow) }
      let!(:task2) { create(:task, created_at: Time.zone.yesterday) }
      let!(:task3) { create(:task, created_at: Time.zone.today) }
      it '順序がタスクの作成日の降順となっていること' do
        get tasks_path
        expect(controller.instance_variable_get(:@tasks)).to eq [task1, task3, task2]
      end
    end

    context 'ソート条件あり' do
      let!(:task4) { create(:task, deadline:Time.zone.tomorrow) }
      let!(:task5) { create(:task, deadline:Time.zone.yesterday) }
      let!(:task6) { create(:task, deadline:Time.zone.today) }
      it '締め切り日の降順でソートが行われること' do
        get tasks_path, params: { order_column: 'deadline', order: 'asc' }
        expect(controller.instance_variable_get(:@tasks)).to eq [task5, task6, task4]
      end

      it '締め切り日の昇順でソートが行われること' do
        get tasks_path, params: { order_column: 'deadline', order: 'desc' }
        expect(controller.instance_variable_get(:@tasks)).to eq [task4, task6, task5]
      end
    end
  end

  describe '#show' do
    context 'リクエストしたタスクが存在しているとき' do
      let!(:task) { create(:task) }

      it 'リクエストがステータスコード200で成功すること' do
        get task_path task
        expect(response).to have_http_status 200
      end
    end

    context 'リクエストしたタスクが存在しないとき' do
      it 'リクエストがステータスコード404で失敗すること' do
        get task_path 1
        expect(response).to have_http_status 404
      end
    end
  end

  describe '#new' do
    it 'リクエストがステータスコード200で成功すること' do
      get new_task_path
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end
  end

  describe '#edit' do
    let!(:task) { create(:task) }

    it 'リクエストがステータスコード200で成功すること' do
      get edit_task_path task
      expect(response).to have_http_status 200
    end
  end

  describe '#create' do
    it 'リクエストがステータスコード302でリダイレクトすること' do
      post tasks_path, params: { task: attributes_for(:task) }
      expect(response).to have_http_status 302
      expect(response).to redirect_to Task.last
    end
  end

  describe '#update' do
    let!(:task) { create(:task) }

    it 'リクエストがステータスコード302でリダイレクトすること' do
      put task_path task, params: { task: attributes_for(:task, name:'update name', detail:'update detail') }
      expect(response).to have_http_status 302
      expect(response).to redirect_to Task.last
    end
  end

  describe '#destroy' do
    let!(:task) { create(:task) }

    it 'リクエストがステータスコード302でリダイレクトすること' do
      delete task_path task
      expect(response).to have_http_status 302
      expect(response).to redirect_to(tasks_path)
    end
  end
end
