class Subject < ActiveRecord::Base
  belongs_to :career
  belongs_to :faculty
  has_many :course_groups, dependent: :destroy
  has_many :subject_prerequisites, foreign_key: :subject_id, dependent: :destroy
  has_many :prerequisites, through: :subject_prerequisites, source: :prerequisite
  has_many :inverse_subject_prerequisites, class_name: 'SubjectPrerequisite', foreign_key: :prerequisite_id, dependent: :destroy
  has_many :dependent_subjects, through: :inverse_subject_prerequisites, source: :subject

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :credits, presence: true, numericality: { greater_than: 0 }
  validates :typology, presence: true, inclusion: { in: %w[B P O L], message: "%{value} no es una tipologia valida de la UNAL (B, P, O, L)" }
  validates :faculty_id, presence: true

  def typology_name
    case typology
    when 'B' then 'Basica de Facultad'
    when 'P' then 'Disciplinar u Obligatoria'
    when 'O' then 'Optativa / Elegible'
    when 'L' then 'Libre Eleccion'
    else 'No Definida'
    end
  end

  def typology_badge_class
    case typology
    when 'B' then 'label-primary'
    when 'P' then 'label-success'
    when 'O' then 'label-info'
    when 'L' then 'label-warning'
    else 'label-default'
    end
  end
end
