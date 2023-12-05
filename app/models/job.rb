# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#  user_id    :integer
#
class Job < ApplicationRecord
  belongs_to(:company,
    class_name: "Company",
    foreign_key: "company_id"
  )
  belongs_to(:user,
    class_name: "User",
    foreign_key: "user_id"
  )
end
