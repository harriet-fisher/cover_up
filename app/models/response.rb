# == Schema Information
#
# Table name: responses
#
#  id              :integer          not null, primary key
#  body            :text
#  response_number :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  message_id      :integer
#  user_id         :integer
#
class Response < ApplicationRecord
  belongs_to(:message,
    class_name: "Message",
    foreign_key: "message_id"
  )
end
