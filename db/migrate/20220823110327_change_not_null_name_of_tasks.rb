class ChangeNotNullNameOfTasks < ActiveRecord::Migration[7.0]
  def change
    change_column :tasks, :name, :text, null: false
  end
end
