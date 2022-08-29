class ChangeNotnullNameOfTasks < ActiveRecord::Migration[7.0]
  def up
    change_column :tasks, :name, :text, null: false
  end

  def down
    change_column :tasks, :name, :text, null: true
  end
end
