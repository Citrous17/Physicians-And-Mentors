class AddNameToSpecialties < ActiveRecord::Migration[8.0]
  def change
    add_column :specialties, :name, :string
  end
end
