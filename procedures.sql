USE HUMANROBOT;
GO

-- Procédure pour ajouter des robots à une usine
IF OBJECT_ID('SP_AddRobotsToFactory', 'P') IS NOT NULL
    DROP PROCEDURE SP_AddRobotsToFactory;
GO

CREATE PROCEDURE SP_AddRobotsToFactory
    @FactoryName VARCHAR(50),
    @RobotModel VARCHAR(50),
    @Quantity INT,
    @DateAdded DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FactoryId INT;
    DECLARE @RobotId INT;
    
    -- Récupérer l'ID de l'usine
    SELECT @FactoryId = id FROM factories WHERE name = @FactoryName;
    IF @FactoryId IS NULL
    BEGIN
        RAISERROR('Usine introuvable', 16, 1);
        RETURN;
    END;
    
    -- Récupérer l'ID du robot
    SELECT @RobotId = id FROM robots WHERE model = @RobotModel;
    IF @RobotId IS NULL
    BEGIN
        RAISERROR('Modele de robot introuvable', 16, 1);
        RETURN;
    END;
    
    -- Vérifier la quantité
    IF @Quantity <= 0
    BEGIN
        RAISERROR('La quantite doit etre positive', 16, 1);
        RETURN;
    END;
    
    -- Insérer dans new_robots (le trigger mettra à jour le stock automatiquement)
    IF @DateAdded IS NULL
        SET @DateAdded = GETDATE();
    
    INSERT INTO new_robots (date_added, numbers_robots_added, id_factorie, id_robot)
    VALUES (@DateAdded, @Quantity, @FactoryId, @RobotId);
    
    PRINT CONCAT(@Quantity, ' robot(s) ', @RobotModel, ' ajoute(s) a ', @FactoryName);
END;
GO

-- Procédure pour ajouter des pièces à une usine
IF OBJECT_ID('SP_AddPartsToFactory', 'P') IS NOT NULL
    DROP PROCEDURE SP_AddPartsToFactory;
GO

CREATE PROCEDURE SP_AddPartsToFactory
    @FactoryName VARCHAR(50),
    @PartName VARCHAR(50),
    @Quantity INT,
    @DateAdded DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FactoryId INT;
    DECLARE @PartId INT;
    
    -- Récupérer l'ID de l'usine
    SELECT @FactoryId = id FROM factories WHERE name = @FactoryName;
    IF @FactoryId IS NULL
    BEGIN
        RAISERROR('Usine introuvable', 16, 1);
        RETURN;
    END;
    
    -- Récupérer l'ID de la pièce
    SELECT @PartId = id FROM parts WHERE name = @PartName;
    IF @PartId IS NULL
    BEGIN
        RAISERROR('Piece introuvable', 16, 1);
        RETURN;
    END;
    
    -- Vérifier la quantité
    IF @Quantity <= 0
    BEGIN
        RAISERROR('La quantite doit etre positive', 16, 1);
        RETURN;
    END;
    
    -- Insérer dans new_part (le trigger mettra à jour le stock automatiquement)
    IF @DateAdded IS NULL
        SET @DateAdded = GETDATE();
    
    INSERT INTO new_part (count_pieces, piece_added, id_part, id_factorie)
    VALUES (@Quantity, @DateAdded, @PartId, @FactoryId);
    
    PRINT CONCAT(@Quantity, ' piece(s) ', @PartName, ' ajoutee(s) a ', @FactoryName);
END;
GO

-- Procédure pour obtenir le stock d'une usine
IF OBJECT_ID('SP_GetFactoryStock', 'P') IS NOT NULL
    DROP PROCEDURE SP_GetFactoryStock;
GO

CREATE PROCEDURE SP_GetFactoryStock
    @FactoryName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FactoryId INT;
    
    -- Récupérer l'ID de l'usine
    SELECT @FactoryId = id FROM factories WHERE name = @FactoryName;
    IF @FactoryId IS NULL
    BEGIN
        RAISERROR('Usine introuvable', 16, 1);
        RETURN;
    END;
    
    -- Afficher le stock de robots
    SELECT 
        r.model AS 'Modele Robot',
        sr.numbers_of_robots AS 'Quantite'
    FROM stock_robot sr
    INNER JOIN robots r ON sr.id_robot = r.id
    WHERE sr.id_factorie = @FactoryId
    ORDER BY r.model;
    
    -- Afficher le stock de pièces
    SELECT 
        p.name AS 'Nom Piece',
        s.numbers_of_pieces AS 'Quantite'
    FROM stocks s
    INNER JOIN parts p ON s.id = p.id
    WHERE s.id_factorie = @FactoryId
    ORDER BY p.name;
END;
GO

-- Procédure pour obtenir les travailleurs actifs d'une usine
IF OBJECT_ID('SP_GetActiveWorkers', 'P') IS NOT NULL
    DROP PROCEDURE SP_GetActiveWorkers;
GO

CREATE PROCEDURE SP_GetActiveWorkers
    @FactoryName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FactoryId INT;
    
    -- Récupérer l'ID de l'usine
    SELECT @FactoryId = id FROM factories WHERE name = @FactoryName;
    IF @FactoryId IS NULL
    BEGIN
        RAISERROR('Usine introuvable', 16, 1);
        RETURN;
    END;
    
    -- Afficher les travailleurs actifs
    SELECT 
        w.firstname AS 'Prenom',
        w.lastname AS 'Nom',
        w.age AS 'Age',
        c.start_contract AS 'Date Debut',
        c.end_contract AS 'Date Fin'
    FROM contracts c
    INNER JOIN workers w ON c.id_worker = w.id
    WHERE c.id_factorie = @FactoryId
        AND (c.end_contract IS NULL OR c.end_contract >= GETDATE())
    ORDER BY w.lastname, w.firstname;
END;
GO

-- Procédure pour obtenir l'historique des ajouts de robots
IF OBJECT_ID('SP_GetRobotHistory', 'P') IS NOT NULL
    DROP PROCEDURE SP_GetRobotHistory;
GO

CREATE PROCEDURE SP_GetRobotHistory
    @FactoryName VARCHAR(50) = NULL,
    @RobotModel VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        f.name AS 'Usine',
        r.model AS 'Modele Robot',
        nr.date_added AS 'Date Ajout',
        nr.numbers_robots_added AS 'Quantite Ajoutee'
    FROM new_robots nr
    INNER JOIN factories f ON nr.id_factorie = f.id
    INNER JOIN robots r ON nr.id_robot = r.id
    WHERE (@FactoryName IS NULL OR f.name = @FactoryName)
        AND (@RobotModel IS NULL OR r.model = @RobotModel)
    ORDER BY nr.date_added DESC, f.name, r.model;
END;
GO

PRINT 'Procedures stockees creees avec succes';
GO

