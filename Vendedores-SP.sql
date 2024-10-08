--EMPLEANDO LA BASE DE DATOS NORTHWIND
--2. CREAR UN SP QUE RECIBA EL ID DE UN EMPLEADO Y REGRESE SU NOMBRE, EL TOTAL DE VENTAS Y EL TOTAL DE PIEZAS VENDIDAS
--   POR ESE EMPLEADO.
--3. EJECUTAR EL SP, RECUPERAR SU INFORMACIÓN Y EVALUARLA:
--   SI EL TOTAL DE VENTAS ES MAYOR A 100 Y EL TOTAL DE PIEZAS ES MAYOR A 2000: IMPRIMIR EL NOMBRE DEL EMPLEADO Y LA
--   LEYENDA "ES UN BUEN VENDEDOR", DE LO CONTRARIO: IMPRIMIR EL NOMBRE JUNTO CON LA LEYENDA "NO ES BUEN VENDEDOR".

CREATE OR ALTER PROCEDURE SP_INFO_VENTAS (@IDEMPLEADO INT, @NombreCto VARCHAR(20) OUT, @TotalVentas INT OUT, @PiezasVendidas INT OUT)
AS
BEGIN
	DECLARE @EmpleadoNoExistente VARCHAR(60) = 'El ID: ' + CONVERT(nvarchar(10),@IDEMPLEADO) + ' del empleado no existe en la Base de Datos'
	IF EXISTS (SELECT  EmployeeID FROM Employees WHERE EmployeeID = @IDEMPLEADO) 
	  BEGIN
		--Guardamos el nombre completo en la variable
			SELECT @NombreCto = CONCAT(E.FirstName,' ',E.LastName) 
								FROM Employees E
								WHERE E.EmployeeID = @IDEMPLEADO
		--Gaurdamos el total de ventas 
			SELECT @TotalVentas = COUNT(O.OrderID) , @PiezasVendidas = SUM(OD.Quantity) 
					FROM Orders O
					JOIN [Order Details] OD 
					ON O.OrderID = OD.OrderID
					WHERE O.EmployeeID = @IDEMPLEADO
					GROUP BY O.EmployeeID
	  END
	ELSE
	  BEGIN
		RAISERROR(@EmpleadoNoExistente,16,1);
	  END
END;


DECLARE @NOMBRE VARCHAR(20), @VENTAS INT, @PIEZAS INT
EXECUTE SP_INFO_VENTAS 1,@NOMBRE OUT,@VENTAS OUT, @PIEZAS OUT 
IF (@VENTAS > 200 and @PIEZAS > 2000) 
	BEGIN
		PRINT CONCAT(@NOMBRE,' ','es un buen vendedor')
	END
ELSE
	BEGIN
		PRINT CONCAT(@NOMBRE,' ','es un mal vendedor')
	END;