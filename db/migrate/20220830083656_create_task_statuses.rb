class CreateTaskStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :task_statuses do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_reference :tasks, :task_status, foreign_key: true
  end
end
