class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :student_code, null: false
      t.string :document, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.references :career, index: true, foreign_key: true, null: false
      t.string :status, default: 'Activo'
      t.string :entry_period, default: '2022-1'
      t.decimal :papa, precision: 3, scale: 2, default: 0.0
      t.decimal :pappi, precision: 3, scale: 2, default: 0.0
      t.decimal :percentage_advance, precision: 5, scale: 2, default: 0.0
      t.integer :approved_credits, default: 0

      t.timestamps null: false
    end
    add_index :students, :student_code, unique: true
    add_index :students, :document, unique: true
    add_index :students, :email, unique: true
  end
end
