class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.references :sending_user, foreign_key: { to_table: :users }
      t.datetime :time_sent
      t.references :parent_post, foreign_key: { to_table: :posts }, null: true

      t.timestamps
    end
  end
end
