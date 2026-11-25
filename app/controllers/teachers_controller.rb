class TeachersController < ApplicationController
  def index
    @teachers = Teacher.includes(:faculty).order(:last_name, :first_name)
  end

  def show
    @teacher = Teacher.find(params[:id])
    @faculty = @teacher.faculty
    @course_groups = @teacher.course_groups.includes(:subject, :academic_period).order('academic_periods.code DESC')
  end
end
