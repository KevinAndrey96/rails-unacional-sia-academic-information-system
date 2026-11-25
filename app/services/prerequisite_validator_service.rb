class PrerequisiteValidatorService
  # Validates student eligibility to enroll into a course group
  # Checks:
  # 1. Subject not already approved
  # 2. Student not already enrolled in current period
  # 3. All required prerequisites approved with min grade (default 3.0)
  # 4. Group has available capacity spots
  # 5. Credit quota limits
  def self.can_enroll?(student, course_group)
    subject = course_group.subject
    period = course_group.academic_period
    errors = []

    # Check 1: Already approved
    if student.approved_subjects.include?(subject)
      errors << "La asignatura #{subject.name} (#{subject.code}) ya fue aprobada previamente por el estudiante."
    end

    # Check 2: Already enrolled in this course in current period
    existing_enr = student.enrollments.where(academic_period_id: period.id)
                          .joins(:course_group)
                          .where('course_groups.subject_id = ?', subject.id)
    if existing_enr.exists?
      errors << "El estudiante ya cuenta con una inscripcion activa en #{subject.name} para el periodo #{period.code}."
    end

    # Check 3: Prerequisites verification
    subject.subject_prerequisites.includes(:prerequisite).each do |prereq_rule|
      prereq = prereq_rule.prerequisite
      passed_enrollment = student.enrollments.joins(:course_group)
                                 .where('course_groups.subject_id = ?', prereq.id)
                                 .where('final_grade >= ?', prereq_rule.min_grade)
                                 .first
      unless passed_enrollment
        errors << "Prerrequisito no cumplido: Requiere aprobar #{prereq.name} (#{prereq.code}) con nota minima de #{prereq_rule.min_grade}."
      end
    end

    # Check 4: Capacity
    if course_group.available_spots <= 0
      errors << "El Grupo #{course_group.group_number} no cuenta con cupos disponibles (Capacidad: #{course_group.capacity})."
    end

    # Check 5: Credit quota
    current_enrolled_credits = student.enrollments.where(academic_period_id: period.id)
                                      .joins(course_group: :subject)
                                      .sum('subjects.credits')
    quota = student.credit_quota
    if (current_enrolled_credits + subject.credits) > quota
      errors << "Supera el cupo maximo de creditos del semestre (#{quota} creditos autorizados para su PAPA)."
    end

    {
      eligible: errors.empty?,
      errors: errors,
      subject: subject,
      group: course_group
    }
  end
end
