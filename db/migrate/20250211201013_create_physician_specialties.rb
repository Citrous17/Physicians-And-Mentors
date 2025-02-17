class CreatePhysicianSpecialties < ActiveRecord::Migration[8.0]
  def change
    create_table :physician_specialties do |t|
      t.integer :physician_specialty_id 
      t.references :user_id, foreign_key: { to_table: :users } 
      t.references :specialty, foreign_key: { to_table: :specialties }
      t.timestamps
    end
  end
end