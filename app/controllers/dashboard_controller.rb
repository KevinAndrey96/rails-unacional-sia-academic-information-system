class DashboardController < ApplicationController
  def index
    @faculties_count = Faculty.count
    @careers_count = Career.count
    @students_count = Student.count
    @teachers_count = Teacher.count
    @subjects_count = Subject.count
    @enrollments_count = Enrollment.count

    @recent_students = Student.includes(:career).order(created_at: :desc).limit(5)
    @active_period = AcademicPeriod.find_by(is_active: true) || AcademicPeriod.order(code: :desc).first
    @careers_summary = Career.includes(:faculty, :students).order(:name)
    @average_university_papa = (Student.where('papa > 0').average(:papa) || 0.0).round(2)
  end
end
