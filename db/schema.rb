# encoding: UTF-8
# This file is auto-generated from the current state of the database.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations.

ActiveRecord::Schema.define(version: 20180306204900) do

  create_table "academic_periods", force: :cascade do |t|
    t.string   "code",                       null: false
    t.string   "name",                       null: false
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_active",  default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "academic_periods", ["code"], name: "index_academic_periods_on_code", unique: true

  create_table "careers", force: :cascade do |t|
    t.string   "code",                                   null: false
    t.string   "name",                                   null: false
    t.integer  "faculty_id",                             null: false
    t.string   "degree_level",       default: "Pregrado"
    t.integer  "total_credits",      default: 165
    t.integer  "duration_semesters", default: 10
    t.string   "snies_code"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "careers", ["code"], name: "index_careers_on_code", unique: true
  add_index "careers", ["faculty_id"], name: "index_careers_on_faculty_id"

  create_table "course_groups", force: :cascade do |t|
    t.integer  "subject_id",                      null: false
    t.integer  "academic_period_id",              null: false
    t.integer  "teacher_id",                      null: false
    t.integer  "group_number",       default: 1,  null: false
    t.string   "classroom"
    t.string   "schedule"
    t.integer  "capacity",           default: 35
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "course_groups", ["academic_period_id"], name: "index_course_groups_on_academic_period_id"
  add_index "course_groups", ["subject_id", "academic_period_id", "group_number"], name: "index_course_groups_unique", unique: true
  add_index "course_groups", ["subject_id"], name: "index_course_groups_on_subject_id"
  add_index "course_groups", ["teacher_id"], name: "index_course_groups_on_teacher_id"

  create_table "enrollments", force: :cascade do |t|
    t.integer  "student_id",                                         null: false
    t.integer  "course_group_id",                                    null: false
    t.integer  "academic_period_id",                                 null: false
    t.string   "status",                             default: "Inscrita"
    t.decimal  "final_grade",        precision: 3, scale: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "enrollments", ["academic_period_id"], name: "index_enrollments_on_academic_period_id"
  add_index "enrollments", ["course_group_id"], name: "index_enrollments_on_course_group_id"
  add_index "enrollments", ["student_id", "course_group_id"], name: "index_enrollments_student_group_unique", unique: true
  add_index "enrollments", ["student_id"], name: "index_enrollments_on_student_id"

  create_table "faculties", force: :cascade do |t|
    t.string   "code",                            null: false
    t.string   "name",                            null: false
    t.string   "campus",          default: "Bogota"
    t.string   "dean"
    t.integer  "foundation_year"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "faculties", ["code"], name: "index_faculties_on_code", unique: true

  create_table "students", force: :cascade do |t|
    t.string   "student_code",                                               null: false
    t.string   "document",                                                   null: false
    t.string   "first_name",                                                 null: false
    t.string   "last_name",                                                  null: false
    t.string   "email",                                                      null: false
    t.integer  "career_id",                                                  null: false
    t.string   "status",                                 default: "Activo"
    t.string   "entry_period",                           default: "2022-1"
    t.decimal  "papa",               precision: 3, scale: 2, default: 0.0
    t.decimal  "pappi",              precision: 3, scale: 2, default: 0.0
    t.decimal  "percentage_advance", precision: 5, scale: 2, default: 0.0
    t.integer  "approved_credits",                       default: 0
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "students", ["career_id"], name: "index_students_on_career_id"
  add_index "students", ["document"], name: "index_students_on_document", unique: true
  add_index "students", ["email"], name: "index_students_on_email", unique: true
  add_index "students", ["student_code"], name: "index_students_on_student_code", unique: true

  create_table "subject_prerequisites", force: :cascade do |t|
    t.integer  "subject_id",                                         null: false
    t.integer  "prerequisite_id",                                    null: false
    t.decimal  "min_grade",       precision: 3, scale: 2, default: 3.0
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "subject_prerequisites", ["prerequisite_id"], name: "index_subject_prerequisites_on_prerequisite_id"
  add_index "subject_prerequisites", ["subject_id", "prerequisite_id"], name: "index_subject_prereq_unique", unique: true
  add_index "subject_prerequisites", ["subject_id"], name: "index_subject_prerequisites_on_subject_id"

  create_table "subjects", force: :cascade do |t|
    t.string   "code",                       null: false
    t.string   "name",                       null: false
    t.integer  "credits",        default: 3, null: false
    t.string   "typology",       default: "P", null: false
    t.integer  "career_id"
    t.integer  "faculty_id",                 null: false
    t.integer  "semester_level", default: 1
    t.text     "syllabus"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "subjects", ["career_id"], name: "index_subjects_on_career_id"
  add_index "subjects", ["code"], name: "index_subjects_on_code", unique: true
  add_index "subjects", ["faculty_id"], name: "index_subjects_on_faculty_id"

  create_table "teachers", force: :cascade do |t|
    t.string   "document",                                   null: false
    t.string   "first_name",                                 null: false
    t.string   "last_name",                                  null: false
    t.string   "email",                                      null: false
    t.integer  "faculty_id",                                 null: false
    t.string   "department"
    t.string   "office"
    t.string   "dedication",      default: "Tiempo Completo"
    t.string   "academic_degree", default: "Ph.D."
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "teachers", ["document"], name: "index_teachers_on_document", unique: true
  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true
  add_index "teachers", ["faculty_id"], name: "index_teachers_on_faculty_id"

end
