-------------------------------------------------
---- numeracion con identity
-------------------------------------------------

-- CREAMOS UNA BASE DE DATOS

CREATE DATABASE EJEMPLO_NUMERACION
GO

USE EJEMPLO_NUMERACION
GO

CREATE TABLE OC (ID INT IDENTITY, FECHA DATETIME NOT NULL,
                 CLIENTE VARCHAR(50) NOT NULL)
GO

-- INSERTAMOS LA PRIMER OC

INSERT INTO OC (FECHA,CLIENTE) 
VALUES (GETDATE(),'IBM')

SELECT * FROM OC -- SE GENERO LA OC NUMERO 1

-- INSERTAMOS LA SEGUNDA OC

INSERT INTO OC (FECHA,CLIENTE) 
VALUES (GETDATE(),NULL)

SELECT * FROM OC -- NO SE GENERO REGISTRO

-- INSERTAMOS LA TERCER OC

INSERT INTO OC (FECHA,CLIENTE) 
VALUES (GETDATE(),'MICROSOFT')

SELECT * FROM OC -- SE GENERO LA OC3 Y HAY HUECOS


-------------------------------------------------------------
-----  numeracion con bloqueos 
--------------------------------------------------------------  
CREATE TABLE MOVIMIENTO1 (VALOR INT IDENTITY, NOMBRE CHAR(400))
GO

DROP TABLE MOVIMIENTO1

TRUNCATE TABLE MOVIMIENTO1

DECLARE @N INT
SET @N = 0
WHILE @N < 10000
 BEGIN
   INSERT INTO MOVIMIENTO1 VALUES (@N + 100)
   SET @N = @N + 1
 END

BEGIN TRAN
  INSERT INTO  MOVIMIENTO1 (NOMBRE) VALUES ('PEPE')
ROLLBACK TRAN 
  

SELECT SCOPE_IDENTITY()

SELECT * FROM MOVIMIENTO1

   
CREATE TABLE NUMERADOR (TIPO_COMPROBANTE VARCHAR(100),
                        ULTIMO_NUMERO INT)
GO

INSERT INTO NUMERADOR VALUES ('OC',1)
INSERT INTO NUMERADOR VALUES ('FACTURAS',10)
GO

DROP TABLE OC
GO

CREATE TABLE OC (NUMERO INT, FECHA DATETIME,
                 CLIENTE VARCHAR(50) NOT NULL)

GO

-- creamos un sp

CREATE PROCEDURE USP_GEN_OC @CLIENTE VARCHAR(500)
AS

declare @proximo_numero int

 begin try 

begin tran

update numerador set @proximo_numero 
= ultimo_numero = ultimo_numero + 1 
where tipo_comprobante = 'OC'

INSERT INTO OC VALUES (@proximo_numero,getdate(),@CLIENTE)

commit tran

end try 
begin catch

  rollback tran -- primero hacemos un rollback
  print @@error -- mostramos el error generado
end catch 
GO

-- INSERTAMOS UN VALOR

EXEC USP_GEN_OC 'SQLTO'

-- vemos los resultados
select * from OC

-- HACEMOS FALLAR
EXEC USP_GEN_OC NULL
select * from OC

-- VOLVEMOS A INSERTAR BIEN
EXEC USP_GEN_OC 'MICROSOFT'
select * from OC
