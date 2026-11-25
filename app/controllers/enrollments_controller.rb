class EnrollmentsController < ApplicationController
  def index
    @active_period = AcademicPeriod.find_by(is_active: true) || AcademicPeriod.order(code: :desc).first
    @period_id = params[:period_id] || @active_period.try(:id)
    @periods = AcademicPeriod.order(code: :desc)

    if @period_id.present?
      @enrollments = Enrollment.where(academic_period_id: @period_id)
                               .includes(:student, :academic_period, course_group: [:subject, :teacher])
                               .order('students.last_name ASC')
    else
      @enrollments = Enrollment.includes(:student, :academic_period, course_group: [:subject, :teacher]).limit(50)
    end
  end

  def new
    @student = Student.find_by(id: params[:student_id])
    @active_period = AcademicPeriod.find_by(is_active: true)
    @available_groups = CourseGroup.where(academic_period: @active_period).includes(:subject, :teacher)
    @enrollment = Enrollment.new
  end

  def create
    @student = Student.find(params[:enrollment][:student_id])
    @course_group = CourseGroup.find(params[:enrollment][:course_group_id])
    @academic_period = @course_group.academic_period

    validation = PrerequisiteValidatorService.can_enroll?(@student, @course_group)

    if validation[:eligible]
      @enrollment = Enrollment.new(
        student: @student,
        course_group: @course_group,
        academic_period: @academic_period,
        status: 'Inscrita'
      )
      if @enrollment.save
        redirect_to student_path(@student), notice: "Asignatura #{@course_group.subject.name} inscrita exitosamente."
      else
        redirect_to new_enrollment_path(student_id: @student.id), alert: @enrollment.errors.full_messages.join(', ')
      end
    else
      redirect_to new_enrollment_path(student_id: @student.id), alert: validation[:errors].join(' | ')
    end
  end

  def update_grade
    @enrollment = Enrollment.find(params[:id])
    grade = params[:enrollment][:final_grade].to_f
    if grade >= 0.0 && grade <= 5.0
      @enrollment.update(final_grade: grade)
      redirect_to student_path(@enrollment.student), notice: "Calificacion actualizada para #{@enrollment.course_group.subject.name}: #{grade}."
    else
      redirect_to student_path(@enrollment.student), alert: "La calificacion debe estar en el rango de 0.0 a 5.0."
    end
  end
end
