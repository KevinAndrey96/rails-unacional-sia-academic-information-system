class CreateAcademicPeriods < ActiveRecord::Migration
  def change
    create_table :academic_periods do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.date :start_date
      t.date :end_date
      t.boolean :is_active, default: true

      t.timestamps null: false
    end
    add_index :academic_periods, :code, unique: true
  end
end
