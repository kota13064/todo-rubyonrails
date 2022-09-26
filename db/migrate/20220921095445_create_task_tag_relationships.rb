class CreateTaskTagRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :task_tag_relationships do |t|
      t.references :task, null: false, foreign_key: true, index: false
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :task_tag_relationships, %i[task_id tag_id], unique: true
  end
end
