class Teacher < ActiveRecord::Base
  belongs_to :faculty
  has_many :course_groups, dependent: :nullify
  has_many :subjects, through: :course_groups

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /@unal\.edu\.co\z/i, message: "debe pertenecer al dominio institucional @unal.edu.co" }
  validates :document, presence: true, uniqueness: true
  validates :faculty_id, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
