class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :provider
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
