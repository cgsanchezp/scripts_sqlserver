USE ADVENTUREWORKS
GO

 -- SAMPLING EN PORCENTAJE
SELECT * FROM SALES.SALESORDERDETAIL TABLESAMPLE SYSTEM(2 PERCENT)
-- SAMPLING EN CANTIDAD DE REGISTROS 
SELECT * FROM SALES.SALESORDERDETAIL TABLESAMPLE SYSTEM(500 ROWS)
-- LIMITANDO Y EXTRAYENDO SIEMPRE LA MISMA CANTIDAD DE REGISTROS
SELECT  TOP(100) * FROM
(
 SELECT * FROM SALES.SALESORDERDETAIL TABLESAMPLE SYSTEM(2 PERCENT)
 ) AS TABLA
