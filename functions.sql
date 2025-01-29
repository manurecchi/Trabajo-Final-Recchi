USE BarberiaRecchi;
GO

-- Función para calcular el total de ventas por cliente
CREATE FUNCTION fn_TotalVentasCliente (@ClienteID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Total DECIMAL(10, 2);

    SELECT @Total = SUM(Total)
    FROM Ventas
    WHERE ClienteID = @ClienteID;

    RETURN ISNULL(@Total, 0);
END;
GO

-- Función para obtener el nombre completo de un cliente
CREATE FUNCTION fn_NombreCompletoCliente (@ClienteID INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @NombreCompleto NVARCHAR(255);

    SELECT @NombreCompleto = CONCAT(Nombre, ' ', Apellido)
    FROM Clientes
    WHERE ClienteID = @ClienteID;

    RETURN @NombreCompleto;
END;
GO

-- Función para calcular el stock restante de un producto
CREATE FUNCTION fn_StockProducto (@ProductoID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Stock INT;

    SELECT @Stock = Stock
    FROM Productos
    WHERE ProductoID = @ProductoID;

    RETURN ISNULL(@Stock, 0);
END;
GO

-- Función para obtener el total de pagos realizados por un cliente
CREATE FUNCTION fn_TotalPagosCliente (@ClienteID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalPagos DECIMAL(10, 2);

    SELECT @TotalPagos = SUM(Monto)
    FROM Pagos
    WHERE ClienteID = @ClienteID;

    RETURN ISNULL(@TotalPagos, 0);
END;
GO
