class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments, primary_key: :comment_id do |t|
      t.bigint :parent_post_id, null: false
      t.text :content, null: false
      t.bigint :sending_user_id, null: false
      t.datetime :time_sent, null: false

      t.timestamps
    end

    add_foreign_key :comments, :posts, column: :parent_post_id
    add_foreign_key :comments, :users, column: :sending_user_id

    add_index :comments, :parent_post_id
    add_index :comments, :sending_user_id
  end
end
