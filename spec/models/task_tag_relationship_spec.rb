require 'rails_helper'

RSpec.describe TaskTagRelationship, type: :model do
  before do
    create(:task_status, :todo)
    create(:priority, :high)
  end

  let!(:task) { create(:task) }
  let!(:tag) { create(:tag) }

  context '正常パラメータを送信したとき' do
    it 'バリデーションに引っかからないこと' do
      task_tag_relationship = build(:task_tag_relationship, task:, tag:)
      expect(task_tag_relationship).to be_valid
    end
  end

  context '異常パラメータを送信したとき' do
    it 'tag_idがないとエラーが表示されること' do
      task_tag_relationship = build(:task_tag_relationship, task:, tag_id: nil)
      task_tag_relationship.valid?
      expect(task_tag_relationship.errors[:tag]).to include('を入力してください')
    end

    it 'task_idがないとエラーが表示されること' do
      task_tag_relationship = build(:task_tag_relationship, task_id: nil, tag:)
      task_tag_relationship.valid?
      expect(task_tag_relationship.errors[:task]).to include('を入力してください')
    end
  end
end
