require 'rails_helper'

RSpec.describe TasksController, type: :request do
  describe '#index' do
    let!(:task1) { create(:task, name:'task1', detail:'task detail1', created_at:'2022-08-23T12:00:00.000+09:00') }
    let!(:task2) { create(:task, name:'task2', detail:'task detail2', created_at:'2022-08-15T12:00:00.000+09:00') }
    let!(:task3) { create(:task, name:'task3', detail:'task detail3', created_at:'2022-08-22T12:00:00.000+09:00') }

    it '200OK' do
      get tasks_path
      expect(response).to have_http_status 200
    end

    it 'be success' do
      get tasks_path
      expect(response).to be_successful
    end

    it '順序がタスクの作成日の降順となっていること' do
      get tasks_path
      expect(controller.instance_variable_get(:@tasks)).to eq [task1, task3, task2]
    end
  end
end
