class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :password_digest, :string
    add_column :users, :location, :string
    add_column :users, :DOB, :date
    add_column :users, :phone_number, :string
    add_column :users, :profile_image_url, :string
    add_column :users, :isProfessional, :boolean
  end
end
