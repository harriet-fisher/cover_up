# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  company_body :text
#  company_name :string
#  job_body     :text
#  message_body :text
#  resume       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
#  job_id       :integer
#  user_id      :integer
#
class Message < ApplicationRecord
end
