class AddUserEmailToInviteCodes < ActiveRecord::Migration[8.0]
  def change
    add_column :invite_codes, :user_email, :string
  end
end
