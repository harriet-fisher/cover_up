class AddCompanyToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :company_id, :integer
  end
end
