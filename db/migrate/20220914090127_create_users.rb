class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :admin

      t.timestamps
    end

    add_index :users, :email, unique: true

    add_reference :tasks, :user, foreign_key: true
  end
end
