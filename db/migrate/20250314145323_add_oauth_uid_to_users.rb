class AddOauthUidToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :oauth_uid, :string
  end
end
