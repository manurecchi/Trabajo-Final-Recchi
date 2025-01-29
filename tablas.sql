
-- ===============================
-- CREACIÓN DE TABLAS
-- ===============================

-- Tabla: Clientes
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Telefono NVARCHAR(15)
);

-- Tabla: Productos
CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

-- Tabla: Fact_Ventas (Hechos)
CREATE TABLE Fact_Ventas (
    FactID INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE NOT NULL,
    ProductoID INT NOT NULL,
    ClienteID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioTotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Tabla: Transaccion_Pagos
CREATE TABLE Transaccion_Pagos (
    PagoID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    FechaPago DATE NOT NULL,
    MetodoPago NVARCHAR(50),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Tabla: Transaccion_Envios
CREATE TABLE Transaccion_Envios (
    EnvioID INT IDENTITY(1,1) PRIMARY KEY,
    FactID INT NOT NULL,
    FechaEnvio DATE NOT NULL,
    EstadoEnvio NVARCHAR(50),
    FOREIGN KEY (FactID) REFERENCES Fact_Ventas(FactID)
);

-- Tabla: HistorialPagos (para trigger)
CREATE TABLE HistorialPagos (
    HistorialID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    Fecha DATE NOT NULL,
    Monto DECIMAL(10,2) NOT NULL
);

-- ===============================
-- INSERCIÓN DE DATOS
-- ===============================

-- Insertar datos en Clientes
INSERT INTO Clientes (Nombre, Email, Telefono) VALUES
('Juan Pérez', 'juan.perez@gmail.com', '123456789'),
('María López', 'maria.lopez@gmail.com', '987654321');

-- Insertar datos en Productos
INSERT INTO Productos (Nombre, Descripcion, Precio, Stock) VALUES
('Laptop', 'Laptop de alta gama', 1500.00, 10),
('Mouse', 'Mouse inalámbrico', 20.00, 50),
('Teclado', 'Teclado mecánico', 100.00, 20);

-- ===============================
-- VISTAS
-- ===============================

-- Vista: Ventas por Cliente
CREATE VIEW VentasPorCliente AS
SELECT 
    c.ClienteID, 
    c.Nombre AS Cliente, 
    SUM(f.PrecioTotal) AS TotalVentas
FROM 
    Clientes c
    INNER JOIN Fact_Ventas f ON c.ClienteID = f.ClienteID
GROUP BY 
    c.ClienteID, c.Nombre;

-- Vista: Top Productos Vendidos
CREATE VIEW TopProductosVendidos AS
SELECT 
    p.ProductoID, 
    p.Nombre AS Producto, 
    SUM(f.Cantidad) AS TotalVendidos
FROM 
    Productos p
    INNER JOIN Fact_Ventas f ON p.ProductoID = f.ProductoID
GROUP BY 
    p.ProductoID, p.Nombre
ORDER BY 
    TotalVendidos DESC;

-- Vista: Pagos Recientes
CREATE VIEW PagosRecientes AS
SELECT 
    p.PagoID, 
    c.Nombre AS Cliente, 
    p.Monto, 
    p.FechaPago, 
    p.MetodoPago
FROM 
    Transaccion_Pagos p
    INNER JOIN Clientes c ON p.ClienteID = c.ClienteID
ORDER BY 
    p.FechaPago DESC;

-- Vista: Estado de Envíos
CREATE VIEW EstadoEnvios AS
SELECT 
    e.EnvioID, 
    f.FactID, 
    f.PrecioTotal AS MontoVenta, 
    e.FechaEnvio, 
    e.EstadoEnvio
FROM 
    Transaccion_Envios e
    INNER JOIN Fact_Ventas f ON e.FactID = f.FactID;

-- ===============================
-- STORED PROCEDURES
-- ===============================

-- Procedimiento: Agregar Cliente
CREATE PROCEDURE AgregarCliente
    @Nombre NVARCHAR(100),
    @Email NVARCHAR(100),
    @Telefono NVARCHAR(15)
AS
BEGIN
    INSERT INTO Clientes (Nombre, Email, Telefono)
    VALUES (@Nombre, @Email, @Telefono);
END;

-- Procedimiento: Registrar Venta
CREATE PROCEDURE RegistrarVenta
    @ProductoID INT,
    @ClienteID INT,
    @Cantidad INT,
    @PrecioTotal DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Fact_Ventas (Fecha, ProductoID, ClienteID, Cantidad, PrecioTotal)
    VALUES (GETDATE(), @ProductoID, @ClienteID, @Cantidad, @PrecioTotal);
END;

-- ===============================
-- FUNCIONES
-- ===============================

-- Función: Total de Ventas por Cliente
CREATE FUNCTION TotalVentasCliente (@ClienteID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (
        SELECT SUM(PrecioTotal)
        FROM Fact_Ventas
        WHERE ClienteID = @ClienteID
    );
END;

-- Función: Stock Disponible
CREATE FUNCTION StockDisponible (@ProductoID INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT Stock
        FROM Productos
        WHERE ProductoID = @ProductoID
    );
END;

-- ===============================
-- TRIGGERS
-- ===============================

-- Trigger: Actualizar Stock
CREATE TRIGGER ActualizarStock
ON Fact_Ventas
AFTER INSERT
AS
BEGIN
    UPDATE Productos
    SET Stock = Stock - i.Cantidad
    FROM Productos p
    INNER JOIN inserted i ON p.ProductoID = i.ProductoID;
END;

-- Trigger: Registrar Historial de Pagos
CREATE TRIGGER RegistrarHistorialPagos
ON Transaccion_Pagos
AFTER INSERT
AS
BEGIN
    INSERT INTO HistorialPagos (ClienteID, Fecha, Monto)
    SELECT ClienteID, FechaPago, Monto
    FROM inserted;
END;
