class FacultiesController < ApplicationController
  def index
    @faculties = Faculty.includes(:careers, :teachers, :subjects).order(:name)
  end

  def show
    @faculty = Faculty.find(params[:id])
    @careers = @faculty.careers.order(:name)
    @teachers = @faculty.teachers.order(:last_name, :first_name)
    @subjects = @faculty.subjects.order(:name)
  end
end
