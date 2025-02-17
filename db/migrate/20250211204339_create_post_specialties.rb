class CreatePostSpecialties < ActiveRecord::Migration[8.0]
  def change
    create_table :post_specialties do |t|
      t.references :post, null: false, foreign_key: true
      t.references :specialty, null: false, foreign_key: true

      t.timestamps
    end
  end
end
