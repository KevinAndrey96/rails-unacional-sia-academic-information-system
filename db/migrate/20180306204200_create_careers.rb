class CreateCareers < ActiveRecord::Migration
  def change
    create_table :careers do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.references :faculty, index: true, foreign_key: true, null: false
      t.string :degree_level, default: 'Pregrado'
      t.integer :total_credits, default: 165
      t.integer :duration_semesters, default: 10
      t.string :snies_code

      t.timestamps null: false
    end
    add_index :careers, :code, unique: true
  end
end
