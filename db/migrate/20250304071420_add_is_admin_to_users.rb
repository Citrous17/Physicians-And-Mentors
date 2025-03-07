class AddIsAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :isAdmin, :boolean, default: false, null: false
  end
end
