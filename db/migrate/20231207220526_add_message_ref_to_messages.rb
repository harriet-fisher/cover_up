class AddMessageRefToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :message, foreign_key: true
  end
end
