class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.text :name
      t.text :detail

      t.timestamps
    end
  end
end
