USE HUMANROBOT;
GO

-- Trigger pour mettre à jour automatiquement le stock de robots
-- lorsqu'un nouveau robot est ajouté dans new_robots
IF OBJECT_ID('TR_UpdateStockRobot', 'TR') IS NOT NULL
    DROP TRIGGER TR_UpdateStockRobot;
GO

CREATE TRIGGER TR_UpdateStockRobot
ON new_robots
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Mettre à jour ou insérer dans stock_robot
    MERGE stock_robot AS target
    USING (
        SELECT id_factorie, id_robot, SUM(numbers_robots_added) AS total_added
        FROM inserted
        GROUP BY id_factorie, id_robot
    ) AS source
    ON target.id_factorie = source.id_factorie 
       AND target.id_robot = source.id_robot
    WHEN MATCHED THEN
        UPDATE SET numbers_of_robots = numbers_of_robots + source.total_added
    WHEN NOT MATCHED THEN
        INSERT (id_factorie, id_robot, numbers_of_robots)
        VALUES (source.id_factorie, source.id_robot, source.total_added);
    
    PRINT 'Stock de robots mis a jour automatiquement';
END;
GO

-- Trigger pour mettre à jour automatiquement le stock de pièces
-- lorsqu'une nouvelle pièce est ajoutée dans new_part
IF OBJECT_ID('TR_UpdateStockParts', 'TR') IS NOT NULL
    DROP TRIGGER TR_UpdateStockParts;
GO

CREATE TRIGGER TR_UpdateStockParts
ON new_part
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Mettre à jour ou insérer dans stocks
    MERGE stocks AS target
    USING (
        SELECT id_factorie, id_part, SUM(count_pieces) AS total_added
        FROM inserted
        GROUP BY id_factorie, id_part
    ) AS source
    ON target.id_factorie = source.id_factorie 
       AND target.id = source.id_part
    WHEN MATCHED THEN
        UPDATE SET numbers_of_pieces = numbers_of_pieces + source.total_added
    WHEN NOT MATCHED THEN
        INSERT (id_factorie, id, numbers_of_pieces)
        VALUES (source.id_factorie, source.id_part, source.total_added);
    
    PRINT 'Stock de pieces mis a jour automatiquement';
END;
GO

-- Trigger pour vérifier qu'un contrat ne peut pas être créé
-- si le travailleur a déjà un contrat actif dans la même usine
IF OBJECT_ID('TR_CheckActiveContract', 'TR') IS NOT NULL
    DROP TRIGGER TR_CheckActiveContract;
GO

CREATE TRIGGER TR_CheckActiveContract
ON contracts
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN contracts c
            ON c.id_worker = i.id_worker
            AND c.id_factorie = i.id_factorie
            AND c.id != i.id
        WHERE (c.end_contract IS NULL OR c.end_contract >= GETDATE())
            AND (i.end_contract IS NULL OR i.end_contract >= GETDATE())
    )
    BEGIN
        RAISERROR('Le travailleur a deja un contrat actif dans cette usine', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO

PRINT 'Triggers crees avec succes';
GO

