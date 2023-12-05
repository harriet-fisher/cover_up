class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :job_body
      t.text :company_body
      t.string :company_name
      t.text :message_body
      t.integer :user_id

      t.timestamps
    end
  end
end
