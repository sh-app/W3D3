# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  prereq_id     :integer
#  instructor_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Course < ActiveRecord::Base
  has_many(
    :enrollments,
    class_name: "Enrollment",
    primary_key: :id,
    foreign_key: :course_id
  )

  has_many :enrolled_students, through: :enrollments, source: :user

  belongs_to :prerequisite,
    class_name: "Course",
    primary_key: :id,
    foreign_key: :prereq_id

  belongs_to :instructor,
    class_name: "User",
    primary_key: :id,
    foreign_key: :instructor_id
end
