class Student < ActiveRecord::Base
  belongs_to :career
  has_one :faculty, through: :career
  has_many :enrollments, dependent: :destroy
  has_many :course_groups, through: :enrollments
  has_many :subjects, through: :course_groups

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /@unal\.edu\.co\z/i, message: "debe pertenecer al dominio institucional @unal.edu.co" }
  validates :document, presence: true, uniqueness: true
  validates :student_code, presence: true, uniqueness: true
  validates :career_id, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def calculate_papa
    finished = enrollments.where.not(final_grade: nil)
    return 0.0 if finished.empty?

    total_weighted = 0.0
    total_credits = 0

    finished.includes(course_group: :subject).each do |enr|
      sub = enr.course_group.try(:subject)
      next unless sub
      credits = sub.credits.to_i
      total_weighted += (enr.final_grade.to_f * credits)
      total_credits += credits
    end

    return 0.0 if total_credits.zero?
    (total_weighted / total_credits).round(2)
  end

  def calculate_pappi(academic_period)
    period_enrollments = enrollments.where(academic_period_id: academic_period.id).where.not(final_grade: nil)
    return 0.0 if period_enrollments.empty?

    total_weighted = 0.0
    total_credits = 0

    period_enrollments.includes(course_group: :subject).each do |enr|
      sub = enr.course_group.try(:subject)
      next unless sub
      credits = sub.credits.to_i
      total_weighted += (enr.final_grade.to_f * credits)
      total_credits += credits
    end

    return 0.0 if total_credits.zero?
    (total_weighted / total_credits).round(2)
  end

  def calculate_percentage_advance
    return 0.0 if career.nil? || career.total_credits.to_i.zero?
    approved = approved_credits_total
    percent = (approved.to_f / career.total_credits.to_f) * 100.0
    [percent.round(2), 100.0].min
  end

  def approved_credits_total
    approved_enrollments.includes(course_group: :subject).sum('subjects.credits')
  end

  def approved_enrollments
    enrollments.where('final_grade >= ?', 3.0).where(status: 'Aprobada')
  end

  def approved_subjects
    Subject.joins(course_groups: :enrollments)
           .where('enrollments.student_id = ? AND enrollments.final_grade >= ? AND enrollments.status = ?', id, 3.0, 'Aprobada')
           .distinct
  end

  def academic_standing
    current_papa = papa.to_f
    if current_papa >= 4.2
      'Excelente'
    elsif current_papa >= 3.8
      'Sobresaliente'
    elsif current_papa >= 3.0
      'Normal'
    else
      'Riesgo Academico'
    end
  end

  def credit_quota
    current_papa = papa.to_f
    if current_papa >= 4.0
      24
    elsif current_papa >= 3.5
      20
    elsif current_papa >= 3.0
      16
    else
      12
    end
  end

  def update_academic_metrics!
    self.papa = calculate_papa
    self.approved_credits = approved_credits_total
    self.percentage_advance = calculate_percentage_advance
    save(validate: false)
  end
end
