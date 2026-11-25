class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :course_group
  belongs_to :academic_period
  has_one :subject, through: :course_group

  validates :student_id, presence: true
  validates :course_group_id, presence: true
  validates :academic_period_id, presence: true
  validates :student_id, uniqueness: { scope: :course_group_id, message: "ya se encuentra inscrito en este grupo" }

  before_save :sync_status_from_grade
  after_save :recalculate_student_metrics

  private

  def sync_status_from_grade
    return if final_grade.nil?
    if final_grade.to_f >= 3.0
      self.status = 'Aprobada'
    else
      self.status = 'Reprobada'
    end
  end

  def recalculate_student_metrics
    student.update_academic_metrics! if student.present?
  end
end
