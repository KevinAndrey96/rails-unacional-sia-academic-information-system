class TranscriptsController < ApplicationController
  def show
    @student = Student.find_by!(student_code: params[:student_code])
    @audit = AcademicAuditService.generate_transcript(@student)
  end
end
