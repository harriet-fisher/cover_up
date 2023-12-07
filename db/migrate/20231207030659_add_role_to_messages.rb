class AddRoleToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :role, :string
  end
end
