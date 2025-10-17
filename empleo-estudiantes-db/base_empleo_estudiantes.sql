CREATE DATABASE empleo_estudiantes;
\c empleo_estudiantes;

-- Tabla de usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña TEXT NOT NULL,
    rol VARCHAR(20) CHECK (rol IN ('estudiante', 'moderador', 'admin')) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Perfil de estudiantes
CREATE TABLE estudiantes (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    edad INT CHECK (edad > 0),
    carrera VARCHAR(100),
    nivel_actual VARCHAR(50),
    plan_estudios VARCHAR(20) CHECK (plan_estudios IN ('trimestral', 'cuatrimestral', 'semestral')),
    disponibilidad VARCHAR(20) CHECK (disponibilidad IN ('parcial', 'completo', 'vacaciones')),
    descripcion TEXT,
    curriculum_pdf VARCHAR(255),
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Experiencias laborales
CREATE TABLE experiencias (
    id SERIAL PRIMARY KEY,
    estudiante_id INT REFERENCES estudiantes(id) ON DELETE CASCADE,
    empresa VARCHAR(100),
    puesto VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    descripcion TEXT
);

-- Ofertas de trabajo
CREATE TABLE ofertas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    empresa VARCHAR(150) NOT NULL,
    tipo_contrato VARCHAR(20) CHECK (tipo_contrato IN ('trimestral', 'cuatrimestral', 'semestral', 'vacacional')),
    ubicacion VARCHAR(100),
    salario DECIMAL(10,2),
    estado VARCHAR(20) CHECK (estado IN ('activa', 'pausada', 'cerrada', 'pendiente')) DEFAULT 'pendiente',
    moderador_id INT REFERENCES users(id) ON DELETE SET NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre TIMESTAMP
);

-- Postulaciones de los estudiantes
CREATE TABLE postulaciones (
    id SERIAL PRIMARY KEY,
    estudiante_id INT REFERENCES estudiantes(id) ON DELETE CASCADE,
    oferta_id INT REFERENCES ofertas(id) ON DELETE CASCADE,
    estado VARCHAR(20) CHECK (estado IN ('pendiente', 'aceptado', 'rechazado', 'finalizado')) DEFAULT 'pendiente',
    fecha_postulacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comentario TEXT
);

-- Contratos
CREATE TABLE contratos (
    id SERIAL PRIMARY KEY,
    postulacion_id INT REFERENCES postulaciones(id) ON DELETE CASCADE,
    fecha_inicio DATE,
    fecha_fin DATE,
    renovable BOOLEAN DEFAULT FALSE,
    evaluacion_empresa TEXT,
    evaluacion_estudiante TEXT,
    estado VARCHAR(20) CHECK (estado IN ('activo', 'finalizado', 'renovado')) DEFAULT 'activo'
);

-- Logs administrativos
CREATE TABLE logs_admin (
    id SERIAL PRIMARY KEY,
    admin_id INT REFERENCES users(id) ON DELETE SET NULL,
    accion TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
