class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.integer :credits, null: false, default: 3
      t.string :typology, null: false, default: 'P'
      t.references :career, index: true, foreign_key: true
      t.references :faculty, index: true, foreign_key: true, null: false
      t.integer :semester_level, default: 1
      t.text :syllabus

      t.timestamps null: false
    end
    add_index :subjects, :code, unique: true
  end
end
