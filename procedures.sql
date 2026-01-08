USE HUMANROBOT;
GO

-- ------------------------------------------------------------
-- Procédure : SEED_DATA_WORKERS
-- -> Créer autant de workers que demandé.
-- J'ajoute un contrat pour lier le worker à l'usine (FACTORY_ID),
-- sinon il n'apparaîtrait pas dans les vues liées aux usines.
-- ------------------------------------------------------------
IF OBJECT_ID('SEED_DATA_WORKERS', 'P') IS NOT NULL
    DROP PROCEDURE SEED_DATA_WORKERS;
GO

CREATE PROCEDURE SEED_DATA_WORKERS
    @NB_WORKERS INT,
    @FACTORY_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 0;
    DECLARE @new_id INT;
    DECLARE @random_date DATE;
    DECLARE @start_range DATE = '2065-01-01';
    DECLARE @end_range DATE = '2070-01-01';
    DECLARE @days_range INT = DATEDIFF(DAY, @start_range, @end_range);

    WHILE @i < @NB_WORKERS
    BEGIN
        -- Calcul date aléatoire
        SET @random_date = DATEADD(DAY, FLOOR(RAND() * @days_range), @start_range);

        INSERT INTO workers (firstname, lastname, age)
        VALUES ('temp', 'temp', 20 + FLOOR(RAND() * 40)); -- Age aléatoire 

        SET @new_id = SCOPE_IDENTITY();

        -- Mise à jour avec le format demandé : 'worker_f_' || id
        UPDATE workers
        SET firstname = 'worker_f_' + CAST(@new_id AS VARCHAR),
            lastname  = 'worker_l_' + CAST(@new_id AS VARCHAR)
        WHERE id = @new_id;

        -- Création du contrat 
        INSERT INTO contracts (start_contract, end_contract, id_factorie, id_worker)
        VALUES (@random_date, NULL, @FACTORY_ID, @new_id);

        SET @i = @i + 1;
    END

    PRINT CAST(@NB_WORKERS AS VARCHAR) + ' travailleurs générés pour l''usine ' + CAST(@FACTORY_ID AS VARCHAR);
END;
GO

-- ------------------------------------------------------------
-- Procédure : ADD_NEW_ROBOT
-- -> Créer un nouveau modèle
-- ------------------------------------------------------------
IF OBJECT_ID('ADD_NEW_ROBOT', 'P') IS NOT NULL
    DROP PROCEDURE ADD_NEW_ROBOT;
GO

CREATE PROCEDURE ADD_NEW_ROBOT
    @MODEL_NAME VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        INSERT INTO robots (model)
        VALUES (@MODEL_NAME);
        
        PRINT 'Robot modèle "' + @MODEL_NAME + '" ajouté avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de l''ajout du robot : ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ------------------------------------------------------------
-- Procédure : SEED_DATA_SPARE_PARTS
-- -> Créer autant de "spare parts" qu'indiqué.
-- ------------------------------------------------------------
IF OBJECT_ID('SEED_DATA_SPARE_PARTS', 'P') IS NOT NULL
    DROP PROCEDURE SEED_DATA_SPARE_PARTS;
GO

CREATE PROCEDURE SEED_DATA_SPARE_PARTS
    @NB_SPARE_PARTS INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 0;
    
    WHILE @i < @NB_SPARE_PARTS
    BEGIN
        BEGIN TRY
            -- Insertion d'une pièce avec un nom unique basé sur un UUID pour éviter les doublons
            INSERT INTO parts (name)
            VALUES ('Spare_Part_' + LEFT(NEWID(), 8)); 
        END TRY
        BEGIN CATCH
            -- Ignorer si doublon généré par hasard 
        END CATCH

        SET @i = @i + 1;
    END

    PRINT CAST(@NB_SPARE_PARTS AS VARCHAR) + ' pièces détachées générées.';
END;
GO

PRINT 'Procédures TP Noté créées avec succès';
GO