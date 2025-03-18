class RenameUidToUserIdInUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :uid, :user_id
  end
end
