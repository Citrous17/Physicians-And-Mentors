class UpdateUsersToV7 < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :name
  end
end
