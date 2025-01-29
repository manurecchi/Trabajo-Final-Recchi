-- Crear la base de datos
CREATE DATABASE Barberia;
USE Barberia;

-- Tabla Clientes
CREATE TABLE Clientes (
    id_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(50) NOT NULL,
    telefono_cliente VARCHAR(15),
    email_cliente VARCHAR(50) UNIQUE
);

-- Tabla Barberos
CREATE TABLE Barberos (
    id_barbero INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_barbero VARCHAR(50) NOT NULL,
    experiencia_años INT NOT NULL CHECK (experiencia_años >= 0)
);

-- Tabla Servicios
CREATE TABLE Servicios (
    id_servicio INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
);

-- Tabla Productos
CREATE TABLE Productos (
    id_producto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

-- Tabla Citas
CREATE TABLE Citas (
    id_cita INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fecha_cita DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_barbero INT NOT NULL,
    id_servicio INT NOT NULL
);

-- Agregar las claves foráneas con ALTER TABLE
ALTER TABLE Citas ADD CONSTRAINT fk_citas_clientes 
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Citas ADD CONSTRAINT fk_citas_barberos 
    FOREIGN KEY (id_barbero) REFERENCES Barberos(id_barbero) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Citas ADD CONSTRAINT fk_citas_servicios 
    FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio) ON DELETE CASCADE ON UPDATE CASCADE;