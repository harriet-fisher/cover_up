class CreateResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.integer :response_number
      t.text :body
      t.integer :message_id
      t.integer :user_id

      t.timestamps
    end
  end
end
