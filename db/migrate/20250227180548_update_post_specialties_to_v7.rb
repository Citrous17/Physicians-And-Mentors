class UpdatePostSpecialtiesToV7 < ActiveRecord::Migration[8.0]
  def change
    remove_column :post_specialties, :created_at
    remove_column :post_specialties, :updated_at
  end
end
