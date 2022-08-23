require 'rails_helper'

RSpec.describe Task, type: :model do
context 'invalid parameter' do
    it 'error is displayed if name is blank.' do
      task = build(:task, name: nil)
      task.valid?
      expect(task.errors[:name]).to include('タスク名を入力してください')
    end
  end
end
