
CREATE VIEW vwMissingFKeys
AS
SELECT T.NAME AS TName, C.NAME AS CName, I.Table_Name AS FKTName, I.Column_Name AS FKCName
FROM sys.columns C
INNER JOIN sys.tables T ON
    T.object_id = C.object_id
LEFT OUTER JOIN [INFORMATION_SCHEMA].Key_Column_Usage I ON
    I.Column_Name = C.NAME
WHERE C.NAME LIKE '%ID'
