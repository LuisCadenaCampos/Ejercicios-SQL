/*
--1.CREAR LA TABLA TEMPORAL CON LOS CAMPOS REQUERIDOS #ALUMNOS(MATRICULA, NOMBRE, APP, APM, PROMEDIO, TURNO).
--2.CREAR UN STORE PROCEDURE QUE RECIBA 4 PARAMETROS(MATRICULA, NOMBRE, APP, APM, PROMEDIO), SI EL PROMEDIO ES MAYOR O IGUAL A 7, 
--  SE INSERTARAN ESOS VALORES A LA TABLA, ASIGNANDO AL CAMPO TURNO EL VALOR DE MATUTINO, DE LO CONTRARIO EL VALOR DEL
--  TURNO SERA VESPERTINO.
*/

--A)Crear la tabla temporal alumnos con los campos solicitados
CREATE TABLE #ALUMNOS(
	Matricula INT PRIMARY KEY,
	Nombre VARCHAR(25) NOT NULL, 
	APP VARCHAR(15) NOT NULL,  --Apellido Paterno
	APM VARCHAR(15),  --Apellido Materno
	Promedio FLOAT,
	Turno VARCHAR(15)
)


CREATE OR ALTER PROCEDURE SP_Ubicacion_Alumnos(@Matricula INT ,@Nombre VARCHAR(25),@APP VARCHAR(15),@APM VARCHAR(15),@Promedio FLOAT)
AS 
BEGIN
     IF NOT EXISTS(SELECT * FROM #ALUMNOS WHERE Matricula = @Matricula)
		BEGIN 
		
			DECLARE @PromedioIncorrecto NVARCHAR(60) = 'El promedio ingresado: ' + CONVERT(NVARCHAR(10),@Promedio) + ' es incorrecto o no valido'


				IF @Promedio >= 7.0  and @Promedio <= 10
					BEGIN 
						INSERT INTO #ALUMNOS 
						VALUES (@Matricula,@Nombre,@APP,@APM,@Promedio,'Matutino')
					END 
				ELSE IF @Promedio >= 5.0 AND @Promedio <= 6.9
					BEGIN
						INSERT INTO #ALUMNOS 
						VALUES(@Matricula,@Nombre,@APP,@APM,@Promedio,'Vespertino')
					END;
				ELSE 
					BEGIN
						RAISERROR(@PromedioIncorrecto,16,1);
					END;
		 END 
	 ELSE
		BEGIN 
			RAISERROR('El alumno esta repetido en la Base de Datos',16,2);
		END;
END;


EXEC SP_Ubicacion_Alumnos 1,'Fernando','Mendieta','Zavala',8.9
EXEC SP_Ubicacion_Alumnos 2,'Roberto','Mendez','Chavez',6.5
EXEC SP_Ubicacion_Alumnos 3,'Jimena','Gómez','Gómez',7.6
EXEC SP_Ubicacion_Alumnos 4,'David','Hernandez','Campos',4.0

SELECT * FROM #ALUMNOS 


