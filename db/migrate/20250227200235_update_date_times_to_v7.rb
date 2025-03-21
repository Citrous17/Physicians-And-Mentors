class UpdateDateTimesToV7 < ActiveRecord::Migration[8.0]
  def change
    remove_column :admins, :created_at, :datetime
    remove_column :admins, :updated_at, :datetime


    remove_column :specialties, :created_at, :datetime
    remove_column :specialties, :updated_at, :datetime
  end
end
