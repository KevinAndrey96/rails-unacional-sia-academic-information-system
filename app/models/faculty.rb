class Faculty < ActiveRecord::Base
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  has_many :careers, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :students, through: :careers

  def total_students_count
    students.count
  end

  def total_teachers_count
    teachers.count
  end
end
