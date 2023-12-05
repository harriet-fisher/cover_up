class CreateCoverletters < ActiveRecord::Migration[7.0]
  def change
    create_table :coverletters do |t|
      t.text :body
      t.integer :job_id
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end
  end
end
