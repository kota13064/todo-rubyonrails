require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:task_status) { create(:task_status, :todo) }
  let!(:priority) { create(:priority, :high) }
  let!(:user) { create(:user) }

  # login
  before do
    post login_path, params: { email: user.email, password: user.password }
  end

  describe '#index' do
    it 'リクエストがステータスコード200で成功すること' do
      get tasks_path
      expect(response).to have_http_status :ok
    end

    context 'ソート条件なし' do
      let!(:task1) { create(:task, user:, created_at: Time.zone.tomorrow) }
      let!(:task2) { create(:task, user:, created_at: Time.zone.yesterday) }
      let!(:task3) { create(:task, user:, created_at: Time.zone.today) }

      it '順序がタスクの作成日の降順となっていること' do
        get tasks_path
        expect(controller.instance_variable_get(:@tasks)).to eq [task1, task3, task2]
      end
    end

    context 'ソート条件あり' do
      let!(:task1) { create(:task, user:, deadline: Time.zone.tomorrow, priority: create(:priority, :middle)) }
      let!(:task2) { create(:task, user:, deadline: Time.zone.yesterday, priority:) }
      let!(:task3) { create(:task, user:, deadline: Time.zone.today, priority: create(:priority, :low)) }

      it '締め切り日の降順でソートが行われること' do
        get tasks_path, params: { order_column: 'deadline', order: 'asc' }
        expect(controller.instance_variable_get(:@tasks)).to eq [task2, task3, task1]
      end

      it '締め切り日の昇順でソートが行われること' do
        get tasks_path, params: { order_column: 'deadline', order: 'desc' }
        expect(controller.instance_variable_get(:@tasks)).to eq [task1, task3, task2]
      end

      it '優先度の降順でソートが行われること' do
        get tasks_path, params: { order_column: 'priority_id', order: 'asc' }
        expect(controller.instance_variable_get(:@tasks)).to eq [task2, task1, task3]
      end

      it '優先度の昇順でソートが行われること' do
        get tasks_path, params: { order_column: 'priority_id', order: 'desc' }
        expect(controller.instance_variable_get(:@tasks)).to eq [task3, task1, task2]
      end
    end

    context '検索条件あり' do
      let!(:task1) { create(:task, user:, task_status:) }
      let!(:task2) { create(:task, user:, task_status: create(:task_status, :doing)) }
      let!(:task3) { create(:task, user:, task_status: task2.task_status) }

      it 'ステータス検索が行われること' do
        get tasks_path, params: { task_status_id: task2.task_status.id }
        expect(controller.instance_variable_get(:@tasks)).to eq [task3, task2]
      end

      it 'タスク名検索が行われること' do
        get tasks_path, params: { name: task1.name }
        expect(controller.instance_variable_get(:@tasks)).to eq [task1]
      end
    end
  end

  describe '#show' do
    subject(:get_response) do
      get task_path task
      response
    end

    context 'リクエストしたタスクが存在しているとき' do
      let!(:task) { create(:task) }

      it 'リクエストがステータスコード200で成功すること' do
        expect(get_response).to have_http_status :ok
      end

      it 'レスポンスにタスク名が含まれていること' do
        expect(get_response.body).to include task.name
      end

      it 'レスポンスに詳細が含まれていること' do
        expect(get_response.body).to include task.detail
      end

      it 'レスポンスに終了期限が含まれていること' do
        expect(get_response.body).to include I18n.l task.deadline
      end

      it 'レスポンスにステータスが含まれていること' do
        expect(get_response.body).to include task.task_status.name
      end

      it 'レスポンスに優先度が含まれていること' do
        expect(get_response.body).to include task.priority.name
      end
    end

    context 'リクエストしたタスクが存在しないとき' do
      it 'リクエストがステータスコード404で失敗すること' do
        get task_path 1
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#new' do
    it 'リクエストがステータスコード200で成功すること' do
      get new_task_path
      expect(response).to have_http_status :ok
    end
  end

  describe '#edit' do
    let!(:task) { create(:task) }

    it 'リクエストがステータスコード200で成功すること' do
      get edit_task_path task
      expect(response).to have_http_status :ok
    end
  end

  describe '#create' do
    subject(:post_response) do
      post tasks_path, params: { task: attributes_for(:task) }
      response
    end

    it 'リクエストがステータスコード302でリダイレクトすること' do
      expect(post_response).to have_http_status :found
    end

    it 'リクエストが作ったタスクのページにリダイレクトすること' do
      expect(post_response).to redirect_to Task.last
    end
  end

  describe '#update' do
    subject(:put_response) do
      put task_path task, params: { task: attributes_for(:task, name: 'update name', detail: 'update detail') }
      response
    end

    let!(:task) { create(:task) }

    it 'リクエストがステータスコード302でリダイレクトすること' do
      expect(put_response).to have_http_status :found
    end

    it 'リクエストが編集したタスクのページにリダイレクトすること' do
      expect(put_response).to redirect_to Task.last
    end
  end

  describe '#destroy' do
    subject(:delete_response) do
      delete task_path task
      response
    end

    let!(:task) { create(:task) }

    it 'リクエストがステータスコード302でリダイレクトすること' do
      expect(delete_response).to have_http_status :found
    end

    it 'リクエストがタスク一覧ページにリダイレクトすること' do
      expect(delete_response).to redirect_to(tasks_path)
    end
  end
end
