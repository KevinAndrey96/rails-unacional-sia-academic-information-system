# Universidad Nacional de Colombia - Sistema de Informacion Academica (SIA)
# Seed Data: Facultades, Carreras, Asignaturas, Prerrequisitos, Docentes y Estudiantes

puts "== Limpiando base de datos SIA UNAL =="
Enrollment.destroy_all
CourseGroup.destroy_all
SubjectPrerequisite.destroy_all
Subject.destroy_all
Student.destroy_all
Teacher.destroy_all
Career.destroy_all
Faculty.destroy_all
AcademicPeriod.destroy_all

puts "== 1. Creando Facultades de la Sede Bogota =="
f_ing = Faculty.create!(
  code: 'FAC-ING',
  name: 'Facultad de Ingenieria',
  campus: 'Bogota',
  dean: 'Prof. Maria Alejandra Guzman Martinez',
  foundation_year: 1861
)

f_cie = Faculty.create!(
  code: 'FAC-CIEN',
  name: 'Facultad de Ciencias',
  campus: 'Bogota',
  dean: 'Prof. Giovanny Garavito Cardenas',
  foundation_year: 1965
)

f_med = Faculty.create!(
  code: 'FAC-MED',
  name: 'Facultad de Medicina',
  campus: 'Bogota',
  dean: 'Prof. Javier Eslava Schmalbach',
  foundation_year: 1867
)

f_ecn = Faculty.create!(
  code: 'FAC-ECN',
  name: 'Facultad de Ciencias Economicas',
  campus: 'Bogota',
  dean: 'Prof. Mauricio Perez Salazar',
  foundation_year: 1966
)

f_art = Faculty.create!(
  code: 'FAC-ART',
  name: 'Facultad de Artes',
  campus: 'Bogota',
  dean: 'Prof. Carlos Naranjo Quiceno',
  foundation_year: 1965
)

puts "== 2. Creando Programas Curriculares (Carreras) =="
c_sistemas = Career.create!(
  code: '2542',
  name: 'Ingenieria de Sistemas y Computacion',
  faculty: f_ing,
  degree_level: 'Pregrado',
  total_credits: 165,
  duration_semesters: 10,
  snies_code: '16'
)

c_electronica = Career.create!(
  code: '2541',
  name: 'Ingenieria Electronica',
  faculty: f_ing,
  degree_level: 'Pregrado',
  total_credits: 168,
  duration_semesters: 10,
  snies_code: '17'
)

c_civil = Career.create!(
  code: '2540',
  name: 'Ingenieria Civil',
  faculty: f_ing,
  degree_level: 'Pregrado',
  total_credits: 172,
  duration_semesters: 10,
  snies_code: '18'
)

c_medicina = Career.create!(
  code: '2550',
  name: 'Medicina',
  faculty: f_med,
  degree_level: 'Pregrado',
  total_credits: 360,
  duration_semesters: 12,
  snies_code: '19'
)

c_estadistica = Career.create!(
  code: '2530',
  name: 'Estadistica',
  faculty: f_cie,
  degree_level: 'Pregrado',
  total_credits: 140,
  duration_semesters: 8,
  snies_code: '20'
)

puts "== 3. Creando Docentes =="
t_aponte = Teacher.create!(
  document: '79845120',
  first_name: 'Jairo Hernan',
  last_name: 'Aponte Melo',
  email: 'japonte@unal.edu.co',
  faculty: f_ing,
  department: 'Ingenieria de Sistemas e Industrial',
  office: 'Edif. 453 - Aulas de Ingenieria, Of. 301',
  dedication: 'Dedicacion Exclusiva',
  academic_degree: 'Ph.D.'
)

t_leon = Teacher.create!(
  document: '52481023',
  first_name: 'Elizabeth',
  last_name: 'Leon Guzman',
  email: 'eleonguz@unal.edu.co',
  faculty: f_ing,
  department: 'Ingenieria de Sistemas e Industrial',
  office: 'Edif. 453 - Aulas de Ingenieria, Of. 302',
  dedication: 'Dedicacion Exclusiva',
  academic_degree: 'Ph.D.'
)

t_gonzalez = Teacher.create!(
  document: '80124789',
  first_name: 'Fabio Augusto',
  last_name: 'Gonzalez Osorio',
  email: 'fagonzalezo@unal.edu.co',
  faculty: f_ing,
  department: 'Ingenieria de Sistemas e Industrial',
  office: 'Edif. 453 - Aulas de Ingenieria, Of. 305',
  dedication: 'Dedicacion Exclusiva',
  academic_degree: 'Ph.D.'
)

t_ortiz = Teacher.create!(
  document: '79354112',
  first_name: 'Jorge Eduardo',
  last_name: 'Ortiz Trivino',
  email: 'jeortizt@unal.edu.co',
  faculty: f_ing,
  department: 'Ingenieria de Sistemas e Industrial',
  office: 'Edif. 453 - Aulas de Ingenieria, Of. 308',
  dedication: 'Tiempo Completo',
  academic_degree: 'Ph.D.'
)

t_pedraza = Teacher.create!(
  document: '79112445',
  first_name: 'Cesar Augusto',
  last_name: 'Pedraza Bonilla',
  email: 'cpedraza@unal.edu.co',
  faculty: f_ing,
  department: 'Ingenieria Electrica y Electronica',
  office: 'Edif. 411 - Laboratorios de Ingenieria, Of. 204',
  dedication: 'Tiempo Completo',
  academic_degree: 'Ph.D.'
)

puts "== 4. Creando Asignaturas (Tipologia UNAL B, P, O, L) =="
s_catedra = Subject.create!(
  code: '2015000',
  name: 'Catedra de Sede: Retos de la Sociedad Colombiana',
  credits: 3,
  typology: 'L',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 1,
  syllabus: 'Espacio transversal para el debate y comprension de las problematicas contemporaneas de Colombia.'
)

s_poo = Subject.create!(
  code: '2016698',
  name: 'Programacion Orientada a Objetos',
  credits: 3,
  typology: 'B',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 2,
  syllabus: 'Paradigmas de programacion, encapsulamiento, herencia, polimorfismo y diseno orientado a objetos.'
)

s_ed = Subject.create!(
  code: '2016699',
  name: 'Estructuras de Datos',
  credits: 3,
  typology: 'P',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 3,
  syllabus: 'Listas, pilas, colas, arboles binarios, grafos, tablas hash y complejidad algoritmica Asintotica O.'
)

s_arq = Subject.create!(
  code: '2016700',
  name: 'Arquitectura de Computadores',
  credits: 3,
  typology: 'P',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 4,
  syllabus: 'Organizacion de procesadores, microarquitectura, memoria jerarquica, buses y lenguaje ensamblador.'
)

s_so = Subject.create!(
  code: '2016705',
  name: 'Sistemas Operativos',
  credits: 3,
  typology: 'P',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 5,
  syllabus: 'Procesos, hilos, planificacion de CPU, sincronizacion y mutex, memoria virtual y sistemas de archivos.'
)

s_redes = Subject.create!(
  code: '2016701',
  name: 'Redes de Computadores',
  credits: 3,
  typology: 'P',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 5,
  syllabus: 'Modelo OSI y TCP/IP, enrutamiento IP, protocolos de transporte, switching Ethernet y seguridad de red.'
)

s_bd = Subject.create!(
  code: '2016702',
  name: 'Bases de Datos',
  credits: 3,
  typology: 'P',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 4,
  syllabus: 'Modelo relacional, algebra relacional, normalizacion SQL, transacciones ACID y modelado NoSQL.'
)

s_ing_soft = Subject.create!(
  code: '2016712',
  name: 'Ingenieria de Software II',
  credits: 3,
  typology: 'P',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 6,
  syllabus: 'Patrones arquitectonicos, microservicios, integracion continua, aseguramiento de calidad y metodologias agiles.'
)

s_ia = Subject.create!(
  code: '2016710',
  name: 'Inteligencia Artificial',
  credits: 3,
  typology: 'O',
  career: c_sistemas,
  faculty: f_ing,
  semester_level: 7,
  syllabus: 'Busqueda en espacios de estados, sistemas basados en reglas, aprendizaje automatico y redes neuronales.'
)

puts "== 5. Creando Prerrequisitos Curriculares =="
SubjectPrerequisite.create!(subject: s_ed, prerequisite: s_poo, min_grade: 3.0)
SubjectPrerequisite.create!(subject: s_so, prerequisite: s_ed, min_grade: 3.0)
SubjectPrerequisite.create!(subject: s_redes, prerequisite: s_arq, min_grade: 3.0)
SubjectPrerequisite.create!(subject: s_bd, prerequisite: s_ed, min_grade: 3.0)
SubjectPrerequisite.create!(subject: s_ing_soft, prerequisite: s_bd, min_grade: 3.0)
SubjectPrerequisite.create!(subject: s_ia, prerequisite: s_ed, min_grade: 3.0)

puts "== 6. Creando Periodos Academicos =="
p_2024_2 = AcademicPeriod.create!(
  code: '2024-2',
  name: 'Segundo Semestre Academico 2024',
  start_date: Date.new(2024, 8, 1),
  end_date: Date.new(2024, 12, 10),
  is_active: false
)

p_2025_1 = AcademicPeriod.create!(
  code: '2025-1',
  name: 'Primer Semestre Academico 2025',
  start_date: Date.new(2025, 2, 3),
  end_date: Date.new(2025, 6, 15),
  is_active: false
)

p_2025_2 = AcademicPeriod.create!(
  code: '2025-2',
  name: 'Segundo Semestre Academico 2025',
  start_date: Date.new(2025, 8, 4),
  end_date: Date.new(2025, 12, 12),
  is_active: false
)

p_2026_1 = AcademicPeriod.create!(
  code: '2026-1',
  name: 'Primer Semestre Academico 2026',
  start_date: Date.new(2026, 2, 2),
  end_date: Date.new(2026, 6, 19),
  is_active: true
)

puts "== 7. Creando Grupos de Cursos =="
g_poo_2024_2 = CourseGroup.create!(
  subject: s_poo,
  academic_period: p_2024_2,
  teacher: t_aponte,
  group_number: 1,
  classroom: 'Edif. 453 - Salon 201',
  schedule: 'Lun, Mie 07:00 - 09:00',
  capacity: 35
)

g_catedra_2024_2 = CourseGroup.create!(
  subject: s_catedra,
  academic_period: p_2024_2,
  teacher: t_leon,
  group_number: 1,
  classroom: 'Edif. 401 - Auditorio Leon de Greiff',
  schedule: 'Vie 14:00 - 17:00',
  capacity: 100
)

g_ed_2025_1 = CourseGroup.create!(
  subject: s_ed,
  academic_period: p_2025_1,
  teacher: t_leon,
  group_number: 1,
  classroom: 'Edif. 453 - Salon 203',
  schedule: 'Mar, Jue 09:00 - 11:00',
  capacity: 30
)

g_arq_2025_1 = CourseGroup.create!(
  subject: s_arq,
  academic_period: p_2025_1,
  teacher: t_pedraza,
  group_number: 1,
  classroom: 'Edif. 411 - Laboratorio 102',
  schedule: 'Lun, Mie 11:00 - 13:00',
  capacity: 25
)

g_so_2025_2 = CourseGroup.create!(
  subject: s_so,
  academic_period: p_2025_2,
  teacher: t_aponte,
  group_number: 1,
  classroom: 'Edif. 453 - Salon 302',
  schedule: 'Mar, Jue 14:00 - 16:00',
  capacity: 30
)

g_redes_2025_2 = CourseGroup.create!(
  subject: s_redes,
  academic_period: p_2025_2,
  teacher: t_ortiz,
  group_number: 1,
  classroom: 'Edif. 453 - Salon 304',
  schedule: 'Lun, Mie 09:00 - 11:00',
  capacity: 30
)

g_bd_2025_2 = CourseGroup.create!(
  subject: s_bd,
  academic_period: p_2025_2,
  teacher: t_gonzalez,
  group_number: 1,
  classroom: 'Edif. 453 - Salon 205',
  schedule: 'Mie, Vie 07:00 - 09:00',
  capacity: 35
)

# Active period groups (2026-1)
g_ing_soft_2026_1 = CourseGroup.create!(
  subject: s_ing_soft,
  academic_period: p_2026_1,
  teacher: t_aponte,
  group_number: 1,
  classroom: 'Edif. 453 - Salon 301',
  schedule: 'Lun, Mie 09:00 - 11:00',
  capacity: 30
)

g_ia_2026_1 = CourseGroup.create!(
  subject: s_ia,
  academic_period: p_2026_1,
  teacher: t_gonzalez,
  group_number: 1,
  classroom: 'Edif. 453 - Salon 202',
  schedule: 'Mar, Jue 07:00 - 09:00',
  capacity: 30
)

puts "== 8. Creando Estudiantes e Historial Academico =="
# Estudiante Insignia: Kevin Andrey Herrera Silva
st_kevin = Student.create!(
  student_code: '1018475920',
  document: '1018475920',
  first_name: 'Kevin Andrey',
  last_name: 'Herrera Silva',
  email: 'kaherrerasi@unal.edu.co',
  career: c_sistemas,
  status: 'Activo',
  entry_period: '2024-2'
)

# Estudiante 2
st_vivi = Student.create!(
  student_code: '1018475921',
  document: '1018475921',
  first_name: 'Viviana Andrea',
  last_name: 'Arango',
  email: 'varangop@unal.edu.co',
  career: c_sistemas,
  status: 'Activo',
  entry_period: '2024-2'
)

# Estudiante 3
st_andres = Student.create!(
  student_code: '1018475922',
  document: '1018475922',
  first_name: 'Andres Felipe',
  last_name: 'Moreno Perez',
  email: 'afmoreno@unal.edu.co',
  career: c_sistemas,
  status: 'Activo',
  entry_period: '2024-2'
)

puts "== 9. Matriculando y Calificando Asignaturas =="
# Kevin Andrey - Historial academico sobresaliente
# 2024-2
Enrollment.create!(student: st_kevin, course_group: g_poo_2024_2, academic_period: p_2024_2, final_grade: 4.8)
Enrollment.create!(student: st_kevin, course_group: g_catedra_2024_2, academic_period: p_2024_2, final_grade: 4.5)

# 2025-1
Enrollment.create!(student: st_kevin, course_group: g_ed_2025_1, academic_period: p_2025_1, final_grade: 4.6)
Enrollment.create!(student: st_kevin, course_group: g_arq_2025_1, academic_period: p_2025_1, final_grade: 4.4)

# 2025-2
Enrollment.create!(student: st_kevin, course_group: g_so_2025_2, academic_period: p_2025_2, final_grade: 4.7)
Enrollment.create!(student: st_kevin, course_group: g_redes_2025_2, academic_period: p_2025_2, final_grade: 4.5)
Enrollment.create!(student: st_kevin, course_group: g_bd_2025_2, academic_period: p_2025_2, final_grade: 4.6)

# 2026-1 (En Curso)
Enrollment.create!(student: st_kevin, course_group: g_ing_soft_2026_1, academic_period: p_2026_1, status: 'Inscrita')
Enrollment.create!(student: st_kevin, course_group: g_ia_2026_1, academic_period: p_2026_1, status: 'Inscrita')

# Viviana - Historial
Enrollment.create!(student: st_vivi, course_group: g_poo_2024_2, academic_period: p_2024_2, final_grade: 4.2)
Enrollment.create!(student: st_vivi, course_group: g_catedra_2024_2, academic_period: p_2024_2, final_grade: 4.4)
Enrollment.create!(student: st_vivi, course_group: g_ed_2025_1, academic_period: p_2025_1, final_grade: 4.1)

# Andres - Historial
Enrollment.create!(student: st_andres, course_group: g_poo_2024_2, academic_period: p_2024_2, final_grade: 3.8)
Enrollment.create!(student: st_andres, course_group: g_catedra_2024_2, academic_period: p_2024_2, final_grade: 4.0)

# Recalcular metricas de estudiantes
[st_kevin, st_vivi, st_andres].each(&:update_academic_metrics!)

puts "== Semillas cargadas exitosamente =="
puts "Total Facultades: #{Faculty.count}"
puts "Total Carreras: #{Career.count}"
puts "Total Asignaturas: #{Subject.count}"
puts "Total Docentes: #{Teacher.count}"
puts "Total Estudiantes: #{Student.count}"
puts "PAPA de Kevin Andrey: #{st_kevin.reload.papa} (Avance: #{st_kevin.percentage_advance}%)"
