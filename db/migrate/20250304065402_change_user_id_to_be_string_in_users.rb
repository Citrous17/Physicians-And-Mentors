class ChangeUserIdToBeStringInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :user_id, :string
  end
end
