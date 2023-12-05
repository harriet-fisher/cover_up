# == Schema Information
#
# Table name: coverletters
#
#  id         :integer          not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#  job_id     :integer
#  user_id    :integer
#
class Coverletter < ApplicationRecord
  belongs_to(:company,
    class_name: "Company",
    foreign_key: "company_id"
  )
  belongs_to(:job,
    class_name: "Job",
    foreign_key: "job_id"
  )
  belongs_to(:user,
    class_name: "User",
    foreign_key: "user_id"
  )
end
