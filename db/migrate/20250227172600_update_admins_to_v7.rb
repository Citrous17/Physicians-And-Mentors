class UpdateAdminsToV7 < ActiveRecord::Migration[8.0]
  def change
    remove_column :admins, :permissions, :string
    add_column :admins, :canEditDatabase, :boolean, default: true
  end
end
