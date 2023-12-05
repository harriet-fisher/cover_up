class AddResumeToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :resume, :text
  end
end
