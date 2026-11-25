class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :document, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.references :faculty, index: true, foreign_key: true, null: false
      t.string :department
      t.string :office
      t.string :dedication, default: 'Tiempo Completo'
      t.string :academic_degree, default: 'Ph.D.'

      t.timestamps null: false
    end
    add_index :teachers, :document, unique: true
    add_index :teachers, :email, unique: true
  end
end
