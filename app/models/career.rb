class Career < ActiveRecord::Base
  belongs_to :faculty
  has_many :students, dependent: :destroy
  has_many :subjects, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :total_credits, presence: true, numericality: { greater_than: 0 }
  validates :faculty_id, presence: true

  def active_students_count
    students.where(status: 'Activo').count
  end

  def average_papa
    active = students.where(status: 'Activo').where('papa > 0')
    return 0.0 if active.empty?
    (active.sum(:papa) / active.count).round(2)
  end
end
