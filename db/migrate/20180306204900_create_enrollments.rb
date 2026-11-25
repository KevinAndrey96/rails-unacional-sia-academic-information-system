class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :student, index: true, foreign_key: true, null: false
      t.references :course_group, index: true, foreign_key: true, null: false
      t.references :academic_period, index: true, foreign_key: true, null: false
      t.string :status, default: 'Inscrita'
      t.decimal :final_grade, precision: 3, scale: 2

      t.timestamps null: false
    end
    add_index :enrollments, [:student_id, :course_group_id], unique: true, name: 'index_enrollments_student_group_unique'
  end
end
