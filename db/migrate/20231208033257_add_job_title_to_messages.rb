class AddJobTitleToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :job_title, :string
  end
end
