class CreateCourseGroups < ActiveRecord::Migration
  def change
    create_table :course_groups do |t|
      t.references :subject, index: true, foreign_key: true, null: false
      t.references :academic_period, index: true, foreign_key: true, null: false
      t.references :teacher, index: true, foreign_key: true, null: false
      t.integer :group_number, default: 1, null: false
      t.string :classroom
      t.string :schedule
      t.integer :capacity, default: 35

      t.timestamps null: false
    end
    add_index :course_groups, [:subject_id, :academic_period_id, :group_number], unique: true, name: 'index_course_groups_unique'
  end
end
