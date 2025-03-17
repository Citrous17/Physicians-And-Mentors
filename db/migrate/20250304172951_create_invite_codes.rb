class CreateInviteCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :invite_codes do |t|
      t.string :code
      t.datetime :expires_at
      t.boolean :used
      t.integer :user_id

      t.timestamps
    end
  end
end
