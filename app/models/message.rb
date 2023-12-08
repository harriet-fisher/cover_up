# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  company_body :text
#  company_name :string
#  job_body     :text
#  job_title    :string
#  message_body :text
#  resume       :text
#  role         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
#  job_id       :integer
#  message_id   :integer
#  user_id      :integer
#
# Indexes
#
#  index_messages_on_message_id  (message_id)
#
# Foreign Keys
#
#  message_id  (message_id => messages.id)
#
class Message < ApplicationRecord
  has_one_attached :resume
  has_many(:responses,
    class_name: "Response",
    foreign_key: "message_id"
  )
end
