class AddJobToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :job_id, :integer
  end
end
