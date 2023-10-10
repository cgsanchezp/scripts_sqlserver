USE ADVENTUREWORKS
GO

select Vendorid,isnull([2001],0) as A2001, 
Isnull([2002],0) AS A2002,Isnull([2003],0) AS A2003,
Isnull([2004],0) AS A2004,Isnull([2005],0) AS A2005
from (
      select vendorid,year(orderdate) as Y,
      freight from purchasing.purchaseorderheader
      ) as Orden
PIVOT (
       sum(Freight) for Y in ([2001],[2002],[2003],
       [2004],[2005],[2006])
      )
as pvt

--------------------------------------------------------------------------------
-- DE FILAS A COLUMNAS CON PIVOT
---------------------------------------------------------------------
-- VEMOS PRIMERO COMO ESTA LA DATA ORIGINAL

SELECT s.Name ShiftName,
h.EmployeeID,
d.Name DepartmentName
FROM HumanResources.EmployeeDepartmentHistory h
INNER JOIN HumanResources.Department d ON
h.DepartmentID = d.DepartmentID
INNER JOIN HumanResources.Shift s ON
h.ShiftID = s.ShiftID
WHERE EndDate IS NULL AND
d.Name IN ('Production', 'Engineering', 'Marketing')
ORDER BY ShiftName

-- LA CONVERTIMOS A COLUMNAS

SELECT ShiftName,Production,Engineering,Marketing
FROM
     (
      SELECT s.Name ShiftName,h.EmployeeID,
             d.Name DepartmentName
      FROM HumanResources.EmployeeDepartmentHistory h
      INNER JOIN HumanResources.Department d ON
      h.DepartmentID = d.DepartmentID
      INNER JOIN HumanResources.Shift s ON
      h.ShiftID = s.ShiftID
      WHERE EndDate IS NULL AND
      d.Name IN ('Production', 'Engineering', 'Marketing')
     ) AS a
PIVOT
(
 COUNT(EmployeeID)
 FOR DepartmentName IN ([Production], [Engineering], [Marketing])
)
AS b
ORDER BY ShiftName

-- Normalizing Data with UNPIVOT

CREATE TABLE dbo.Contact
(EmployeeID int NOT NULL,
PhoneNumber1 bigint,
PhoneNumber2 bigint,
PhoneNumber3 bigint)
GO

INSERT dbo.Contact
(EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3)
VALUES( 1, 2718353881, 3385531980, 5324571342)
INSERT dbo.Contact
(EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3)
VALUES( 2, 6007163571, 6875099415, 7756620787)
INSERT dbo.Contact
(EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3)
VALUES( 3, 9439250939, NULL, NULL)

SELECT * FROM dbo.Contact

-- DE COLUMNAS A FILAS CON UNPIVOT

SELECT EmployeeID,
PhoneType,
PhoneValue
FROM
    (
     SELECT EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3
     FROM dbo.Contact
    ) c
UNPIVOT
(
 PhoneValue FOR PhoneType IN ([PhoneNumber1], [PhoneNumber2],
 [PhoneNumber3])
) AS p
