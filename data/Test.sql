SELECT TOP (1000) [Nom]
      ,[Genre]
      ,[Ã‰pisodes]
      ,[Score]
      ,[Rank]
      ,[TÃ©lÃ©spectateurs]
      ,[Acteurs]
      ,[Date Debut]
      ,[Date Fin]
 
  FROM [Drama].[dbo].[Cdrama$]


 -- Creer une table avec des données non doubles 

  SELECT DISTINCT *
INTO DramaChinois
FROM [Drama].[dbo].[Cdrama$];


-- Supprimer la colonne 
  ALTER TABLE [Drama].[dbo].[Cdrama$]
DROP COLUMN F10;

Select *
from [Drama].[dbo].[Cdrama$];






Select * from DramaChinois
 

 -- compter le nombre de ligne 
Select COUNT(*)  as NombreDeLigne from DramaChinois


-- Verifier les données types


SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'DramaChinois';


-- Changer les noms des Colonnes 
EXEC sp_rename 'DramaChinois.Ã‰pisodes', 'Episodes', 'COLUMN';
EXEC sp_rename 'DramaChinois.TÃ©lÃ©spectateurs', 'Telespectateurs', 'COLUMN';
EXEC sp_rename 'DramaChinois.Nom', 'Titre', 'COLUMN';
EXEC sp_rename 'DramaChinois.Date Fin', 'DateFin', 'COLUMN';
EXEC sp_rename 'DramaChinois.Date Debut', 'DateDebut', 'COLUMN';

-- Verifier les doublons 

SELECT
    Titre,
    COUNT(*) AS doublons
FROM
    DramaChinois
    
  
GROUP BY
Titre
HAVING
    COUNT(*) > 1;


	--- Deuxième pour identifier les doublons 

	WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Titre, Genre, Episodes, Score, Rank, 
                            Telespectateurs, Acteurs, DateDebut, DateFin 
               ORDER BY DateDebut
           ) AS row_num
    FROM DramaChinois
)
SELECT * FROM duplicate_cte WHERE row_num > 1;


--- Uniformiser les données 

-- Supprimer les 2024 contenu dans les données

UPDATE DramaChinois
SET Titre = REPLACE(Titre, ' (2024)', '')
WHERE Titre LIKE '% (2024)';

UPDATE DramaChinois
SET Episodes = REPLACE(Episodes, '.0', '')
WHERE Episodes LIKE '%.0%';

---Formatage de la colonne date
UPDATE DramaChinois
SET Episodes = TRY_CONVERT(FLOAT, Episodes),
    Rank = TRY_CONVERT(FLOAT, Rank),
    Score = TRY_CONVERT(FLOAT, Score);


	ALTER TABLE DramaChinois 
ALTER COLUMN Episodes FLOAT;

ALTER TABLE DramaChinois 
ALTER COLUMN Rank FLOAT;

ALTER TABLE DramaChinois 
ALTER COLUMN Score FLOAT;

BEGIN TRANSACTION;

ALTER TABLE DramaChinois 
ALTER COLUMN DateDebut DATE;

ALTER TABLE DramaChinois 
ALTER COLUMN DateFin DATE;


---- Conversion date 


SELECT DateDebut 
FROM DramaChinois
WHERE TRY_CONVERT(DATE, DateDebut, 107) IS NULL AND DateDebut IS NOT NULL;


-- Utilisation de FORMAT pour transformer les mois en nombre
SELECT 
    CASE 
        WHEN DateDebut LIKE '%Jan%' THEN REPLACE(DateDebut, 'Jan', '01')
        WHEN DateDebut LIKE '%Feb%' THEN REPLACE(DateDebut, 'Feb', '02')
        WHEN DateDebut LIKE '%Mar%' THEN REPLACE(DateDebut, 'Mar', '03')
        WHEN DateDebut LIKE '%Apr%' THEN REPLACE(DateDebut, 'Apr', '04')
        WHEN DateDebut LIKE '%May%' THEN REPLACE(DateDebut, 'May', '05')
        WHEN DateDebut LIKE '%Jun%' THEN REPLACE(DateDebut, 'Jun', '06')
        WHEN DateDebut LIKE '%Jul%' THEN REPLACE(DateDebut, 'Jul', '07')
        WHEN DateDebut LIKE '%Aug%' THEN REPLACE(DateDebut, 'Aug', '08')
        WHEN DateDebut LIKE '%Sep%' THEN REPLACE(DateDebut, 'Sep', '09')
        WHEN DateDebut LIKE '%Oct%' THEN REPLACE(DateDebut, 'Oct', '10')
        WHEN DateDebut LIKE '%Nov%' THEN REPLACE(DateDebut, 'Nov', '11')
        WHEN DateDebut LIKE '%Dec%' THEN REPLACE(DateDebut, 'Dec', '12')
        ELSE DateDebut
    END AS ReformattedDate
FROM DramaChinois;
SELECT 
    TRY_CONVERT(DATE, 
        CASE 
            WHEN DateDebut LIKE '%Jan%' THEN REPLACE(DateDebut, 'Jan', '01')
            WHEN DateDebut LIKE '%Feb%' THEN REPLACE(DateDebut, 'Feb', '02')
            WHEN DateDebut LIKE '%Mar%' THEN REPLACE(DateDebut, 'Mar', '03')
            WHEN DateDebut LIKE '%Apr%' THEN REPLACE(DateDebut, 'Apr', '04')
            WHEN DateDebut LIKE '%May%' THEN REPLACE(DateDebut, 'May', '05')
            WHEN DateDebut LIKE '%Jun%' THEN REPLACE(DateDebut, 'Jun', '06')
            WHEN DateDebut LIKE '%Jul%' THEN REPLACE(DateDebut, 'Jul', '07')
            WHEN DateDebut LIKE '%Aug%' THEN REPLACE(DateDebut, 'Aug', '08')
            WHEN DateDebut LIKE '%Sep%' THEN REPLACE(DateDebut, 'Sep', '09')
            WHEN DateDebut LIKE '%Oct%' THEN REPLACE(DateDebut, 'Oct', '10')
            WHEN DateDebut LIKE '%Nov%' THEN REPLACE(DateDebut, 'Nov', '11')
            WHEN DateDebut LIKE '%Dec%' THEN REPLACE(DateDebut, 'Dec', '12')
            ELSE DateDebut
        END, 103) AS ConvertedDate
FROM DramaChinois;


BEGIN TRANSACTION;

-- Essai de conversion des dates
SELECT TRY_CONVERT(DATE, DateDebut, 107) 
FROM DramaChinois;

-- Si tout est bon, commit
COMMIT TRANSACTION;

-- En cas d'erreur, rollback
ROLLBACK TRANSACTION;


BEGIN TRANSACTION;
UPDATE DramaChinois
SET DateDebut = TRY_CONVERT(DATE, DateDebut, 107),
    DateFin = TRY_CONVERT(DATE, DateFin, 107);



	SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'DramaChinois';



---Supprimer des données unitils
Delete from DramaChinois 
Where score >10

--- Connaitre le rank 
SELECT * FROM DramaChinois
ORDER BY Rank ASC;

SELECT * FROM DramaChinois
WHERE Genre LIKE '%Historical%'
ORDER BY Score Desc
;


SELECT * FROM DramaChinois

ORDER BY Score Desc
;


