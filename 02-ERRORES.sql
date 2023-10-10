USE ADVENTUREWORKS
GO

-- CREAMOS UNA TABLA LA CUAL USAREMOS LUEGO

IF OBJECT_ID('EMPLEADOS') IS NOT NULL
   DROP TABLE EMPLEADOS
GO

CREATE TABLE EMPLEADOS (LEGAJO INT PRIMARY KEY, NOMBRE VARCHAR(30),
                       FECHA DATETIME,EDAD INT
                       CHECK (EDAD >=18 AND EDAD <=70))
GO 

-- INSERTAMOS UN REGISTRO

INSERT INTO EMPLEADOS VALUES (1,'MARIANO','20060101',37)

-- INTENTAMOS INSERTAR UN REGISTRO QUE NO CUMPLE CON EL CHECK

INSERT INTO EMPLEADOS VALUES (2,'JUAN','20060101',3)                        

-- HACEMOS CONTROL DE ERRORES

SET NOCOUNT ON

BEGIN TRY
   INSERT INTO EMPLEADOS VALUES (2,'JUAN','20060101',3)                        
END TRY

BEGIN CATCH
   SELECT ERROR_NUMBER() AS NUMERO,
          ERROR_SEVERITY() AS SEVERIDAD,
          ERROR_STATE() AS STADO,
          ERROR_MESSAGE() AS MENSAJE
END CATCH

---------------------------------------------------------------------------------------------
--- MANEJO DE TRANSACCIONES
---------------------------------------------------------------------------------------------

-- INTENTAMOS INSERTAR 2 REGITROS, UNO VALIDO Y EL OTRO NO

BEGIN TRANSACTION

BEGIN TRY
   INSERT INTO EMPLEADOS VALUES (2,'JUAN','20060101',33)                        
    -- REGISTRO NO VALIDO
   INSERT INTO EMPLEADOS VALUES (3,'PEDRO','20060101',3)                           
 
   COMMIT TRANSACTION
END TRY

BEGIN CATCH
   ROLLBACK TRANSACTION
   
   RAISERROR('Se ha generado un error al insertar',16,1)

END CATCH

 -- OBSERVAMOS LOS REGISTROS

SELECT * FROM EMPLEADOS

-------------------------------------------------------------------------------------------------------
----------- ANIDAMIENTO DE ERRORES --------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

-- CREAMOS UNA TABLA PARA AUDITAR ERRORES

IF OBJECT_ID('LOG_ERRORES') IS NOT NULL
   DROP TABLE LOG_ERRORES
GO

CREATE TABLE LOG_ERRORES 
(ID INT IDENTITY,NUMERO BIGINT,MENSAJE VARCHAR(1000) NOT NULL)
GO

SET NOCOUNT ON

  -- DARA UN ERROR PORQUE LA EDAD NO CUMPLE CON EL CHECK
BEGIN TRY
   INSERT INTO EMPLEADOS VALUES (2,'JUAN','20060101',3)                        
END TRY

BEGIN CATCH
   BEGIN TRY
     -- INTENTAMOS INSERTAR EL ERROR EN LA TABLA AUDITORIA PERO NO PASAMOS EL MENSAJE, CON LO CUAL DA ERROR
        INSERT INTO LOG_ERRORES (NUMERO,MENSAJE) VALUES (ERROR_NUMBER(),NULL)
   END TRY
 
   BEGIN CATCH
       PRINT 'NO SE PUDO GUARDAR EN LA TABLA LOG_ERRORES'
   END CATCH

END CATCH

-------------------------------------------------------------------------------------------
--- LIMPIAMOS TODO ------------------------------------------------------------------------

DROP TABLE EMPLEADOS;
DROP TABLE LOG_ERRORES;