class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.string :title
      t.integer :sending_user_id
      t.integer :receiving_user_id
      t.datetime :time_sent
      t.integer :parent_message_id

      t.timestamps
    end
  end
end
