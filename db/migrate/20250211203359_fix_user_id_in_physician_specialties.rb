class FixUserIdInPhysicianSpecialties < ActiveRecord::Migration[8.0]
  def change
    rename_column :physician_specialties, :user_id_id, :user_id
  end
end