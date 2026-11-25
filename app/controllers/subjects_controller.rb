class SubjectsController < ApplicationController
  def index
    @typology = params[:typology]
    if @typology.present?
      @subjects = Subject.includes(:faculty, :career).where(typology: @typology).order(:name)
    else
      @subjects = Subject.includes(:faculty, :career).order(:name)
    end
  end

  def show
    @subject = Subject.find(params[:id])
    @prerequisites = @subject.prerequisites
    @dependent_subjects = @subject.dependent_subjects
    @course_groups = @subject.course_groups.includes(:academic_period, :teacher).order('academic_periods.code DESC')
  end
end
