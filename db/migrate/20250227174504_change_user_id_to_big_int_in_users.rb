class ChangeUserIdToBigIntInUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :user_id
    add_column :users, :user_id, :bigint
  end
end
