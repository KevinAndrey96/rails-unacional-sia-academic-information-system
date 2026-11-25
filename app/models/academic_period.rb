class AcademicPeriod < ActiveRecord::Base
  has_many :course_groups, dependent: :destroy
  has_many :enrollments, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :active, -> { where(is_active: true) }
end
