class CreateSubjectPrerequisites < ActiveRecord::Migration
  def change
    create_table :subject_prerequisites do |t|
      t.references :subject, index: true, null: false
      t.references :prerequisite, index: true, null: false
      t.decimal :min_grade, precision: 3, scale: 2, default: 3.0

      t.timestamps null: false
    end
    add_index :subject_prerequisites, [:subject_id, :prerequisite_id], unique: true, name: 'index_subject_prereq_unique'
  end
end
