class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :campus, default: 'Bogota'
      t.string :dean
      t.integer :foundation_year

      t.timestamps null: false
    end
    add_index :faculties, :code, unique: true
  end
end
