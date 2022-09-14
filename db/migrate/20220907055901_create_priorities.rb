class CreatePriorities < ActiveRecord::Migration[7.0]
  def change
    create_table :priorities do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_reference :tasks, :priority, foreign_key: true
  end
end
