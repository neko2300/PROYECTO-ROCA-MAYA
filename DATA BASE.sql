-- ============================================
-- Creación de Base de Datos
-- ============================================
CREATE DATABASE IF NOT EXISTS Roca_Maya;
USE Roca_Maya;


-- ============================================
-- TABLA: Rol
-- ============================================
CREATE TABLE Rol (
ID_Rol INT AUTO_INCREMENT PRIMARY KEY,
Nombre_Rol VARCHAR(50) NOT NULL UNIQUE,
Descripcion_Rol TEXT
);


-- ============================================
-- TABLA: Usuario
-- ============================================
CREATE TABLE Usuario (
ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
Nombre_Usuario VARCHAR(50) NOT NULL UNIQUE,
Password_Hash VARCHAR(255) NOT NULL,
ID_Rol INT NOT NULL,
Email VARCHAR(100),
Fecha_Creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
Ultimo_Acceso DATETIME,
Nombre_Completo VARCHAR(200),
Numero_Colegiacion VARCHAR(50) UNIQUE NULL,
FOREIGN KEY (ID_Rol) REFERENCES Rol(ID_Rol)
);


-- ============================================
-- TABLA: Paciente
-- ============================================
CREATE TABLE Paciente (
ID_Paciente INT AUTO_INCREMENT PRIMARY KEY,
Nombres VARCHAR(100),
Apellidos VARCHAR(100),
Fecha_Nacimiento DATE,
Genero VARCHAR(10),
Direccion VARCHAR(255),
Telefono VARCHAR(20),
Correo_Electronico VARCHAR(100),
Tipo_Documento_Identidad VARCHAR(50),
Numero_Documento_Identidad VARCHAR(50) UNIQUE,
RTN_Paciente VARCHAR(50)
);


-- ============================================
-- TABLA: Historial_Medico
-- ============================================
CREATE TABLE Historial_Medico (
ID_Historial INT AUTO_INCREMENT PRIMARY KEY,
ID_Paciente INT NOT NULL,
Alergias TEXT,
Enfermedades_Cronicas TEXT,
Cirugias_Previas TEXT,
FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);


-- ============================================
-- TABLA: Nota_Evaluacion_Medica
-- ============================================
CREATE TABLE Nota_Evaluacion_Medica (
ID_Nota INT AUTO_INCREMENT PRIMARY KEY,
ID_Paciente INT NOT NULL,
Fecha_Hora_Registro DATETIME,
Contenido_Nota TEXT,
ID_Medico INT NOT NULL,
Firma_Digital BLOB,
FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
FOREIGN KEY (ID_Medico) REFERENCES Usuario(ID_Usuario)
);


-- ============================================
-- TABLA: Resultado_Laboratorio
-- ============================================
CREATE TABLE Resultado_Laboratorio (
ID_Laboratorio INT AUTO_INCREMENT PRIMARY KEY,
ID_Paciente INT NOT NULL,
Tipo_Examen VARCHAR(100),
Fecha_Realizacion DATETIME,
Resultados TEXT,
Unidades VARCHAR(50),
Valores_Referencia VARCHAR(100),
FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);


-- ============================================
-- TABLA: Factura
-- ============================================
CREATE TABLE Factura (
ID_Factura INT AUTO_INCREMENT PRIMARY KEY,
ID_Paciente INT NOT NULL,
Fecha_Emision DATETIME,
RTN_Paciente VARCHAR(50) NOT NULL,
CAEH VARCHAR(100) NOT NULL,
Numero_Factura VARCHAR(50) NOT NULL UNIQUE,
Estado_Factura VARCHAR(20),
Monto_Total DECIMAL(10,2) CHECK (Monto_Total > 0),
URL_Factura_Electronica VARCHAR(255),
FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);


-- ============================================
-- TABLA: Detalle_Factura
-- ============================================
CREATE TABLE Detalle_Factura (
ID_Detalle_Factura INT AUTO_INCREMENT PRIMARY KEY,
ID_Factura INT NOT NULL,
Descripcion_Servicio VARCHAR(255),
Codigo_CIEO_10 VARCHAR(20) NOT NULL,
Codigo_CUPS VARCHAR(20) NOT NULL,
Cantidad INT NOT NULL CHECK (Cantidad >= 1),
Precio_Unitario DECIMAL(10,2) CHECK (Precio_Unitario > 0),
Subtotal DECIMAL(12,2) GENERATED ALWAYS AS (Cantidad * Precio_Unitario) STORED,
FOREIGN KEY (ID_Factura) REFERENCES Factura(ID_Factura)
);


-- ============================================
-- TABLA: Pago
-- ============================================
CREATE TABLE Pago (
ID_Pago INT AUTO_INCREMENT PRIMARY KEY,
ID_Factura INT NOT NULL,
Fecha_Pago DATETIME,
Monto_Pagado DECIMAL(10,2) CHECK (Monto_Pagado > 0),
Metodo_Pago VARCHAR(50),
Referencia_Pago VARCHAR(100),
Tipo_Pagador VARCHAR(20),
FOREIGN KEY (ID_Factura) REFERENCES Factura(ID_Factura)
);


-- ============================================
-- TABLA: Permiso
-- ============================================
CREATE TABLE Permiso (
ID_Permiso INT AUTO_INCREMENT PRIMARY KEY,
Nombre_Permiso VARCHAR(100) NOT NULL UNIQUE,
Descripcion_Permiso TEXT
);


-- ============================================
-- TABLA: Rol_Permiso
-- ============================================
CREATE TABLE Rol_Permiso (
ID_Rol_Permiso INT AUTO_INCREMENT PRIMARY KEY,
ID_Rol INT NOT NULL,
ID_Permiso INT NOT NULL,
FOREIGN KEY (ID_Rol) REFERENCES Rol(ID_Rol),
FOREIGN KEY (ID_Permiso) REFERENCES Permiso(ID_Permiso)
);


-- ============================================
-- TABLA: Auditoria
-- ============================================
CREATE TABLE Auditoria (
ID_Auditoria INT AUTO_INCREMENT PRIMARY KEY,
ID_Usuario INT NOT NULL,
Fecha_Hora_Accion DATETIME,
Tipo_Accion VARCHAR(50),
Modulo_Afectado VARCHAR(100) NOT NULL,
Tabla_Afectada VARCHAR(100) NOT NULL,
ID_Registro_Afectado INT NOT NULL,
Detalle_Cambio TEXT,
Direccion_IP VARCHAR(45),
FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
);


-- ============================================
-- TABLA: Expediente_Clinico_Basico
-- ============================================
CREATE TABLE Expediente_Clinico_Basico (
ID_Signo_Vital INT AUTO_INCREMENT PRIMARY KEY,
ID_Paciente INT NOT NULL,
ID_Usuario_Enfermeria INT NOT NULL,
Fecha_Hora_Registro DATETIME,
Temperatura DECIMAL(4,2),
Presion_Sistolica INT,
Presion_Diastolica INT,
Frecuencia_Cardiaca INT,
Frecuencia_Respiratoria INT,
Saturacion_Oxigeno DECIMAL(5,2),
FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
FOREIGN KEY (ID_Usuario_Enfermeria) REFERENCES Usuario(ID_Usuario)
);


-- ============================================
-- TABLA: Nota_Evolucion
-- ============================================
CREATE TABLE Nota_Evolucion (
ID_Prescripcion INT AUTO_INCREMENT PRIMARY KEY,
ID_Paciente INT NOT NULL,
ID_Medico INT NOT NULL,
Fecha_Prescripcion DATETIME,
Nombre_Medicamento VARCHAR(100),
Dosis VARCHAR(50),
Frecuencia VARCHAR(50),
Duracion VARCHAR(50),
Instrucciones_Adicionales TEXT,
FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
FOREIGN KEY (ID_Medico) REFERENCES Usuario(ID_Usuario)
);


-- ============================================
-- TABLA EXTRA: Seguridad
-- ============================================
CREATE TABLE Seguridad (
ID_Seguridad INT AUTO_INCREMENT PRIMARY KEY,
ID_Usuario INT NOT NULL,
Intentos_Login INT DEFAULT 0,
Bloqueado BOOLEAN DEFAULT FALSE,
Ultimo_Login DATETIME,
FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
);


-- ============================================
-- TABLA EXTRA: Backup_BD
-- ============================================
CREATE TABLE Backup_BD (
ID_Backup INT AUTO_INCREMENT PRIMARY KEY,
Fecha_Respaldo DATETIME NOT NULL,
Nombre_Archivo VARCHAR(255) NOT NULL,
Ubicacion_Archivo VARCHAR(255) NOT NULL,
Usuario_Responsable INT,
Comentarios TEXT,
FOREIGN KEY (Usuario_Responsable) REFERENCES Usuario(ID_Usuario)
);

-- ============================================
-- TABLA: Auditoria
-- ============================================
CREATE TABLE Auditoria (
  ID_Auditoria INT AUTO_INCREMENT PRIMARY KEY,
  ID_Usuario INT NOT NULL,
  Fecha_Hora_Accion DATETIME DEFAULT CURRENT_TIMESTAMP,
  Tipo_Accion ENUM('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','ERROR') NOT NULL,
  Modulo_Afectado VARCHAR(100) NOT NULL,
  Tabla_Afectada VARCHAR(100) NOT NULL,
  ID_Registro_Afectado INT NULL,
  Valores_Anteriores JSON NULL,
  Valores_Nuevos JSON NULL,
  Direccion_IP VARCHAR(45) NULL,
  FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
);
