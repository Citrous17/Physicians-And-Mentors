class UpdatePhysicianSpecialtiesToV7 < ActiveRecord::Migration[8.0]
  def change
    remove_column :physician_specialties, :created_at
    remove_column :physician_specialties, :updated_at
    remove_column :physician_specialties, :physician_specialty_id
  end
end
