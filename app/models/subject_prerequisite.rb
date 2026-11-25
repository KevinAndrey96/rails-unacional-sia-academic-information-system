class SubjectPrerequisite < ActiveRecord::Base
  belongs_to :subject
  belongs_to :prerequisite, class_name: 'Subject'

  validates :subject_id, presence: true
  validates :prerequisite_id, presence: true
  validates :subject_id, uniqueness: { scope: :prerequisite_id, message: "ya tiene asignado este prerrequisito" }
end
