# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Company < ApplicationRecord
  has_many(:jobs,
    class_name: "Job",
    foreign_key: "company_id"
  )
  belongs_to(:user,
    class_name: "User",
    foreign_key: "user_id"
  )
end
