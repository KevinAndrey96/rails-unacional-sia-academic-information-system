class AcademicAuditService
  # Generates full academic transcript data for a student
  def self.generate_transcript(student)
    career = student.career
    faculty = career.try(:faculty)

    all_enrollments = student.enrollments
                             .includes(:academic_period, course_group: :subject)
                             .order('academic_periods.code ASC, subjects.code ASC')

    typology_breakdown = {
      'B' => { name: 'Basica de Facultad', approved_credits: 0, total_courses: 0 },
      'P' => { name: 'Disciplinar u Obligatoria', approved_credits: 0, total_courses: 0 },
      'O' => { name: 'Optativa / Elegible', approved_credits: 0, total_courses: 0 },
      'L' => { name: 'Libre Eleccion', approved_credits: 0, total_courses: 0 }
    }

    periods_history = {}

    all_enrollments.each do |enr|
      period_code = enr.academic_period.code
      periods_history[period_code] ||= {
        period: enr.academic_period,
        enrollments: [],
        semester_credits: 0,
        weighted_points: 0.0
      }

      sub = enr.course_group.subject
      credits = sub.credits.to_i
      grade = enr.final_grade.to_f

      periods_history[period_code][:enrollments] << enr
      periods_history[period_code][:semester_credits] += credits
      periods_history[period_code][:weighted_points] += (grade * credits) if enr.final_grade.present?

      # Typology stats if approved
      if enr.final_grade.present? && enr.final_grade >= 3.0 && typology_breakdown.key?(sub.typology)
        typology_breakdown[sub.typology][:approved_credits] += credits
        typology_breakdown[sub.typology][:total_courses] += 1
      end
    end

    # Calculate semester averages
    periods_history.each do |_code, data|
      if data[:semester_credits] > 0
        data[:pappi] = (data[:weighted_points] / data[:semester_credits]).round(2)
      else
        data[:pappi] = 0.0
      end
    end

    standing = PapaCalculatorService.academic_standing(student)
    quota = PapaCalculatorService.credit_quota(student)

    {
      student: student,
      career: career,
      faculty: faculty,
      papa: student.calculate_papa,
      percentage_advance: student.calculate_percentage_advance,
      approved_credits: student.approved_credits_total,
      total_career_credits: career.try(:total_credits) || 0,
      standing: standing,
      quota: quota,
      typology_breakdown: typology_breakdown,
      periods_history: periods_history
    }
  end
end
