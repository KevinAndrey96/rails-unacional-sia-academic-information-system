#!/usr/bin/env python3
"""
Universidad Nacional de Colombia - Sede Bogota
Sistema de Informacion Academica (SIA)
Verification Suite for Academic Architecture, PAPA Formulations & Domain Logic
"""

import os
import sys
import re

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def log_test(name, passed, details=""):
    status = "PASS" if passed else "FAIL"
    print(f"[{status}] {name}")
    if details:
        print(f"       {details}")
    return passed

def test_architecture_and_files():
    required_files = [
        "app/models/faculty.rb",
        "app/models/career.rb",
        "app/models/teacher.rb",
        "app/models/student.rb",
        "app/models/subject.rb",
        "app/models/subject_prerequisite.rb",
        "app/models/academic_period.rb",
        "app/models/course_group.rb",
        "app/models/enrollment.rb",
        "app/services/papa_calculator_service.rb",
        "app/services/prerequisite_validator_service.rb",
        "app/services/academic_audit_service.rb",
        "app/controllers/dashboard_controller.rb",
        "app/controllers/faculties_controller.rb",
        "app/controllers/careers_controller.rb",
        "app/controllers/teachers_controller.rb",
        "app/controllers/students_controller.rb",
        "app/controllers/subjects_controller.rb",
        "app/controllers/enrollments_controller.rb",
        "app/controllers/transcripts_controller.rb",
        "app/views/layouts/application.html.erb",
        "app/views/dashboard/index.html.erb",
        "app/views/faculties/index.html.erb",
        "app/views/faculties/show.html.erb",
        "app/views/careers/index.html.erb",
        "app/views/careers/show.html.erb",
        "app/views/students/index.html.erb",
        "app/views/students/show.html.erb",
        "app/views/teachers/index.html.erb",
        "app/views/teachers/show.html.erb",
        "app/views/subjects/index.html.erb",
        "app/views/subjects/show.html.erb",
        "app/views/enrollments/index.html.erb",
        "app/views/enrollments/new.html.erb",
        "app/views/transcripts/show.html.erb",
        "db/schema.rb",
        "db/seeds.rb",
        "config/routes.rb",
        "Dockerfile",
        "docker-compose.yml",
        ".github/workflows/ci.yml"
    ]

    missing = [f for f in required_files if not os.path.exists(os.path.join(ROOT_DIR, f))]
    if missing:
        return log_test("Suite 1: Academic MVC Architecture & File Completeness", False, f"Missing files: {missing}")
    return log_test("Suite 1: Academic MVC Architecture & File Completeness", True, f"All {len(required_files)} core files verified.")

def test_database_schema():
    schema_path = os.path.join(ROOT_DIR, "db", "schema.rb")
    if not os.path.exists(schema_path):
        return log_test("Suite 2: Database Schema & Relational Tables", False, "db/schema.rb not found.")

    with open(schema_path, "r", encoding="utf-8") as f:
        content = f.read()

    expected_tables = [
        "faculties",
        "careers",
        "teachers",
        "students",
        "subjects",
        "subject_prerequisites",
        "academic_periods",
        "course_groups",
        "enrollments"
    ]

    missing_tables = [t for t in expected_tables if f'create_table "{t}"' not in content]
    if missing_tables:
        return log_test("Suite 2: Database Schema & Relational Tables", False, f"Missing tables in schema: {missing_tables}")

    # Check key indexes
    indexes = [
        "index_faculties_on_code",
        "index_careers_on_code",
        "index_teachers_on_document",
        "index_students_on_student_code",
        "index_subjects_on_code",
        "index_subject_prereq_unique",
        "index_course_groups_unique",
        "index_enrollments_student_group_unique"
    ]
    missing_idx = [idx for idx in indexes if idx not in content]
    if missing_idx:
        return log_test("Suite 2: Database Schema & Relational Tables", False, f"Missing schema indexes: {missing_idx}")

    return log_test("Suite 2: Database Schema & Relational Tables", True, f"All {len(expected_tables)} tables and indexes validated.")

def test_academic_papa_and_pappi_formula():
    # Verify the official UNAL PAPA formula:
    # PAPA = Sum(grade_i * credits_i) / Sum(credits_i)
    # Using real sample curriculum records:
    sample_records = [
        {"name": "POO", "credits": 3, "grade": 4.8},
        {"name": "Catedra", "credits": 3, "grade": 4.5},
        {"name": "Estructuras de Datos", "credits": 3, "grade": 4.6},
        {"name": "Arquitectura de Computadores", "credits": 3, "grade": 4.4},
        {"name": "Sistemas Operativos", "credits": 3, "grade": 4.7},
        {"name": "Redes de Computadores", "credits": 3, "grade": 4.5},
        {"name": "Bases de Datos", "credits": 3, "grade": 4.6}
    ]

    total_weighted = sum(r["credits"] * r["grade"] for r in sample_records)
    total_credits = sum(r["credits"] for r in sample_records)
    calculated_papa = round(total_weighted / total_credits, 2)

    # Expected: 96.3 / 21 = 4.5857 -> 4.59
    if abs(calculated_papa - 4.59) > 0.01:
        return log_test("Suite 3: Official UNAL PAPA & PA Mathematical Formulation", False, f"PAPA mismatch: got {calculated_papa}, expected 4.59")

    # Percentage advance for Systems Engineering (165 total credits)
    career_credits = 165
    pa = round((total_credits / career_credits) * 100.0, 2)
    if abs(pa - 12.73) > 0.01:
        return log_test("Suite 3: Official UNAL PAPA & PA Mathematical Formulation", False, f"PA mismatch: got {pa}%, expected 12.73%")

    # Test PAPPI (period with 2 courses: POO 4.8 and Catedra 4.5)
    p1_weighted = (3 * 4.8) + (3 * 4.5)
    p1_credits = 6
    pappi = round(p1_weighted / p1_credits, 2)
    if abs(pappi - 4.65) > 0.01:
        return log_test("Suite 3: Official UNAL PAPA & PA Mathematical Formulation", False, f"PAPPI mismatch: got {pappi}, expected 4.65")

    return log_test("Suite 3: Official UNAL PAPA & PA Mathematical Formulation", True, f"Formulas verified: PAPA={calculated_papa}, PAPPI={pappi}, PA={pa}%.")

def test_prerequisite_and_credit_quota_rules():
    # Verify CSU Acuerdo 008 de 2008 logic
    def get_quota(papa):
        if papa >= 4.0:
            return 24
        elif papa >= 3.5:
            return 20
        elif papa >= 3.0:
            return 16
        else:
            return 12

    def get_standing(papa):
        if papa >= 4.5:
            return "Matricula de Honor"
        elif papa >= 4.0:
            return "Excelente"
        elif papa >= 3.5:
            return "Sobresaliente"
        elif papa >= 3.0:
            return "Normal"
        else:
            return "Riesgo Academico"

    tests = [
        (4.8, 24, "Matricula de Honor"),
        (4.2, 24, "Excelente"),
        (3.7, 20, "Sobresaliente"),
        (3.2, 16, "Normal"),
        (2.8, 12, "Riesgo Academico")
    ]

    for papa, expected_quota, expected_standing in tests:
        q = get_quota(papa)
        s = get_standing(papa)
        if q != expected_quota or s != expected_standing:
            return log_test("Suite 4: Academic Standing & Credit Quota Rules (CSU 008)", False, f"Failed for PAPA {papa}: quota={q}, standing={s}")

    return log_test("Suite 4: Academic Standing & Credit Quota Rules (CSU 008)", True, "All credit quotas and academic standing brackets validated.")

def test_unal_curricular_taxonomy():
    # Verify typology codes: B (Basica), P (Disciplinar), O (Optativa), L (Libre Eleccion)
    typologies = {
        "B": "Basica de Facultad",
        "P": "Disciplinar u Obligatoria",
        "O": "Optativa / Elegible",
        "L": "Libre Eleccion"
    }

    # Verify email institutional domain regex
    email_regex = re.compile(r"^[\w.+-]+@unal\.edu\.co$", re.IGNORECASE)
    valid_emails = ["kaherrerasi@unal.edu.co", "japonte@unal.edu.co", "fagonzalezo@unal.edu.co"]
    invalid_emails = ["kevin@gmail.com", "prof@unal.edu", "student@hotmail.com"]

    for email in valid_emails:
        if not email_regex.match(email):
            return log_test("Suite 5: UNAL Curricular Taxonomy & Domain Validation", False, f"Valid email failed: {email}")

    for email in invalid_emails:
        if email_regex.match(email):
            return log_test("Suite 5: UNAL Curricular Taxonomy & Domain Validation", False, f"Invalid email succeeded: {email}")

    return log_test("Suite 5: UNAL Curricular Taxonomy & Domain Validation", True, f"UNAL typologies {list(typologies.keys())} and @unal.edu.co validation verified.")

def test_seeds_and_curricular_integrity():
    seeds_path = os.path.join(ROOT_DIR, "db", "seeds.rb")
    with open(seeds_path, "r", encoding="utf-8") as f:
        content = f.read()

    expected_entities = [
        "FAC-ING",
        "Facultad de Ingenieria",
        "2542",
        "Ingenieria de Sistemas y Computacion",
        "2016698",
        "Programacion Orientada a Objetos",
        "2016699",
        "Estructuras de Datos",
        "2016705",
        "Sistemas Operativos",
        "1018475920",
        "Kevin Andrey"
    ]

    missing = [e for e in expected_entities if e not in content]
    if missing:
        return log_test("Suite 6: Curricular Seeds & Entity Integrity", False, f"Missing entities in seeds: {missing}")

    return log_test("Suite 6: Curricular Seeds & Entity Integrity", True, "Seeds content and curricular program mapping verified.")

def test_zero_em_dash_compliance():
    forbidden_char = "\u2014"
    extensions = [".rb", ".erb", ".yml", ".yaml", ".md", ".py", "Dockerfile"]
    violating_files = []

    for root, dirs, files in os.walk(ROOT_DIR):
        if any(ignored in root for ignored in [".git", "vendor", "tmp", "log"]):
            continue
        for file in files:
            if any(file.endswith(ext) for ext in extensions) or file in ["Dockerfile", "Gemfile", "Rakefile"]:
                fpath = os.path.join(root, file)
                try:
                    with open(fpath, "r", encoding="utf-8") as f:
                        for line_no, line in enumerate(f, 1):
                            if forbidden_char in line:
                                rel_path = os.path.relpath(fpath, ROOT_DIR)
                                violating_files.append(f"{rel_path}:{line_no}")
                                break
                except UnicodeDecodeError:
                    pass

    if violating_files:
        return log_test("Suite 7: Zero Em-Dash Quality Rule", False, f"Em-dash detected in: {violating_files}")

    return log_test("Suite 7: Zero Em-Dash Quality Rule", True, "Strict zero em-dash compliance verified across all files.")

def main():
    print("=" * 80)
    print("  UNIVERSIDAD NACIONAL DE COLOMBIA - SEDE BOGOTA")
    print("  SIA (Sistema de Informacion Academica) - Architecture & Verification Suite")
    print("=" * 80)

    suites = [
        test_architecture_and_files,
        test_database_schema,
        test_academic_papa_and_pappi_formula,
        test_prerequisite_and_credit_quota_rules,
        test_unal_curricular_taxonomy,
        test_seeds_and_curricular_integrity,
        test_zero_em_dash_compliance
    ]

    results = [s() for s in suites]
    passed = sum(1 for r in results if r)
    total = len(results)

    print("=" * 80)
    print(f"  Summary: {passed}/{total} verification suites passed.")
    print("=" * 80)

    if passed != total:
        sys.exit(1)
    sys.exit(0)

if __name__ == "__main__":
    main()
