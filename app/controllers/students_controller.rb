class StudentsController < ApplicationController
  def index
    @query = params[:q]
    if @query.present?
      q = "%#{@query.strip.downcase}%"
      @students = Student.includes(:career)
                         .where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR student_code LIKE ? OR document LIKE ?', q, q, q, q)
                         .order(:last_name, :first_name)
    else
      @students = Student.includes(:career).order(:last_name, :first_name)
    end
  end

  def show
    @student = Student.find(params[:id])
    @career = @student.career
    @faculty = @student.faculty
    @enrollments = @student.enrollments.includes(:academic_period, course_group: [:subject, :teacher]).order('academic_periods.code DESC')
    @standing = PapaCalculatorService.academic_standing(@student)
    @quota = PapaCalculatorService.credit_quota(@student)
  end

  def transcript
    @student = Student.find(params[:id])
    @audit = AcademicAuditService.generate_transcript(@student)
    render 'transcripts/show'
  end
end
