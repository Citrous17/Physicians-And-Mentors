class UpdateDateTimesToV7 < ActiveRecord::Migration[8.0]
  def change
    remove_column :admins, :created_at, :datetime
    remove_column :admins, :updated_at, :datetime

    remove_column :comments, :created_at, :datetime
    remove_column :comments, :updated_at, :datetime

    remove_column :posts, :created_at, :datetime
    remove_column :posts, :updated_at, :datetime

    remove_column :specialties, :created_at, :datetime
    remove_column :specialties, :updated_at, :datetime

    remove_column :users, :created_at, :datetime
    remove_column :users, :updated_at, :datetime
  end
end
