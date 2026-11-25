class CourseGroup < ActiveRecord::Base
  belongs_to :subject
  belongs_to :academic_period
  belongs_to :teacher
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments

  validates :subject_id, presence: true
  validates :academic_period_id, presence: true
  validates :teacher_id, presence: true
  validates :group_number, presence: true
  validates :capacity, numericality: { greater_than: 0 }

  def available_spots
    capacity.to_i - enrollments.count
  end

  def display_name
    "#{subject.name} - Grupo #{group_number} (#{academic_period.code})"
  end
end
