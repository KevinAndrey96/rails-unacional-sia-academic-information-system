class CareersController < ApplicationController
  def index
    @careers = Career.includes(:faculty, :students).order(:name)
  end

  def show
    @career = Career.find(params[:id])
    @faculty = @career.faculty
    @students = @career.students.order(:last_name, :first_name)
    @subjects_by_level = @career.subjects.order(:semester_level, :code).group_by(&:semester_level)
  end
end
