class PapaCalculatorService
  # Calculates the Official UNAL PAPA (Promedio Aritmetico Ponderado Acumulado)
  # Formula: Sum(grade_i * credits_i) / Sum(credits_i)
  def self.calculate_papa(student)
    finished_enrollments = student.enrollments.where.not(final_grade: nil)
    return 0.0 if finished_enrollments.empty?

    total_weighted = 0.0
    total_credits = 0

    finished_enrollments.includes(course_group: :subject).each do |enr|
      sub = enr.course_group.try(:subject)
      next unless sub
      credits = sub.credits.to_i
      total_weighted += (enr.final_grade.to_f * credits)
      total_credits += credits
    end

    return 0.0 if total_credits.zero?
    (total_weighted / total_credits).round(2)
  end

  # Calculates PAPPI (Promedio Aritmetico Ponderado del Periodo Intersemestral/Academico)
  def self.calculate_pappi(student, academic_period)
    period_enrollments = student.enrollments
                                .where(academic_period_id: academic_period.id)
                                .where.not(final_grade: nil)
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

  # Calculates Percentage of Academic Advance (PA)
  # Formula: Min(100.0, (Approved Credits / Career Total Credits) * 100.0)
  def self.calculate_percentage_advance(student)
    career = student.career
    return 0.0 if career.nil? || career.total_credits.to_i.zero?

    approved_credits = student.approved_credits_total.to_f
    percentage = (approved_credits / career.total_credits.to_f) * 100.0
    [percentage.round(2), 100.0].min
  end

  # Academic standing based on CSU Acuerdo 008 de 2008
  def self.academic_standing(student)
    papa = student.papa.to_f
    if papa >= 4.5
      { status: 'Matricula de Honor', alert: false, badge: 'success' }
    elsif papa >= 4.0
      { status: 'Excelente', alert: false, badge: 'primary' }
    elsif papa >= 3.5
      { status: 'Sobresaliente', alert: false, badge: 'info' }
    elsif papa >= 3.0
      { status: 'Normal', alert: false, badge: 'default' }
    else
      { status: 'Riesgo Academico', alert: true, badge: 'danger' }
    end
  end

  # Semester credit quota based on PAPA performance
  def self.credit_quota(student)
    papa = student.papa.to_f
    if papa >= 4.0
      { quota: 24, label: 'Sobrecarga Academica Autorizada' }
    elsif papa >= 3.5
      { quota: 20, label: 'Cupo Ampliado' }
    elsif papa >= 3.0
      { quota: 16, label: 'Cupo Estandar' }
    else
      { quota: 12, label: 'Cupo Restringido por Alerta' }
    end
  end
end
