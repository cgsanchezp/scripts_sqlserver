USE ADVENTUREWORKS
GO

-----------------------------------------------------------------------------------------------
--- SIN PARTICION
-----------------------------------------------------------------------------------------------

  SELECT FIRSTNAME,LASTNAME,
  ROW_NUMBER() OVER(ORDER BY FIRSTNAME,LASTNAME) AS ROW_NUMBER,
  RANK() OVER(ORDER BY FIRSTNAME,LASTNAME) AS RANK,
  DENSE_RANK() OVER(ORDER BY FIRSTNAME,LASTNAME) AS DENSE_RANK,
  NTILE(3) OVER(ORDER BY FIRSTNAME,LASTNAME) AS 'NTILE(3)'
  FROM PERSON.CONTACT ORDER BY FIRSTNAME


-----------------------------------------------------------------------------------------------
--- CON PARTICION
-----------------------------------------------------------------------------------------------

  SELECT FIRSTNAME,LASTNAME,
  ROW_NUMBER() OVER(PARTITION BY FIRSTNAME ORDER BY LASTNAME) 
  AS ROW_NUMBER,
  RANK() OVER(PARTITION BY FIRSTNAME ORDER BY LASTNAME) AS RANK,
  DENSE_RANK() OVER(PARTITION BY FIRSTNAME ORDER BY LASTNAME)
  AS DENSE_RANK,
  NTILE(3) OVER(PARTITION BY FIRSTNAME ORDER BY LASTNAME) AS 'NTILE(3)'
  FROM PERSON.CONTACT ORDER BY FIRSTNAME

---------------------------------------------------------------------------------
-- USANDO ROW_NUMBER EN EL WHERE
--------------------------------------------------------------------------------

  SELECT * FROM 
    (SELECT FIRSTNAME,ROW_NUMBER() OVER(ORDER BY FIRSTNAME) AS ROW
     FROM PERSON.CONTACT) TABLA
  WHERE ROW >=10 AND ROW <=20

  