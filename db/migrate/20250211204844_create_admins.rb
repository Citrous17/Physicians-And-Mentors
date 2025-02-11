class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.references :user, null: false, foreign_key: true
      t.string :permissions

      t.timestamps
    end
  end
end
