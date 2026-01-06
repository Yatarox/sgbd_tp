--creation de la base de donnees si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HUMANROBOT')
BEGIN
    CREATE DATABASE HUMANROBOT;
END
ELSE
BEGIN
    PRINT 'La base de donnees HUMANROBOT existe deja';
END
GO

USE HUMANROBOT;
GO

PRINT 'utilisation de la base de donnees HUMANROBOT';
GO

--creation de la table workers
IF OBJECT_ID('workers', 'U') IS NULL
BEGIN
    CREATE TABLE workers (
        id INT PRIMARY KEY IDENTITY(1,1),
        firstname VARCHAR(50) NOT NULL,
        lastname VARCHAR(50) NOT NULL,
        age INT NOT NULL
    );
     PRINT 'Table workers créée';
END
ELSE
BEGIN
    PRINT 'La table workers existe deja';
END
GO

--creation de la table factories
IF OBJECT_ID('factories', 'U') IS NULL
BEGIN
    CREATE TABLE factories (
        id INT PRIMARY KEY IDENTITY(1,1),
        name VARCHAR(50) NOT NULL UNIQUE,
        date_of_creation DATE NOT NULL
    );
    PRINT 'Table factories créée';
END
ELSE
BEGIN
    PRINT 'Table factories existe déjà';
END
GO

--creation de la table contracts
IF OBJECT_ID('contracts', 'U') IS NULL
BEGIN
    CREATE TABLE contracts (
        id INT PRIMARY KEY IDENTITY(1,1),
        start_contract DATE NOT NULL,
        end_contract DATE NULL,
        id_factorie INT NOT NULL,
        id_worker INT NOT NULL,
        CONSTRAINT FK_Contracts_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
        CONSTRAINT FK_Contracts_Worker FOREIGN KEY (id_worker) REFERENCES workers(id),
        CONSTRAINT CHK_Contracts_Dates CHECK (end_contract IS NULL OR end_contract >= start_contract)
    );
    PRINT 'Table contracts créée';
END
ELSE
BEGIN
    PRINT 'Table contracts existe déjà';
END
GO

--creation de la table robots
IF OBJECT_ID('robots', 'U') IS NULL
BEGIN
    CREATE TABLE robots (
        id INT PRIMARY KEY IDENTITY(1,1),
        model VARCHAR(50) NOT NULL UNIQUE
    );
    PRINT 'Table robots créée';
END
ELSE
BEGIN
    PRINT 'Table robots existe déjà';
END
GO

--creation de la table stocks_robot
IF OBJECT_ID('stock_robot', 'U') IS NULL
BEGIN
    CREATE TABLE stock_robot (
        id_factorie INT NOT NULL,
        id_robot INT NOT NULL,
        numbers_of_robots INT NOT NULL CHECK (numbers_of_robots >= 0),
        PRIMARY KEY (id_factorie, id_robot),
        CONSTRAINT FK_StockRobot_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
        CONSTRAINT FK_StockRobot_Robot FOREIGN KEY (id_robot) REFERENCES robots(id)
    );
    PRINT 'Table stock_robot créée';
END
ELSE
BEGIN
    PRINT 'Table stock_robot existe déjà';
END
GO

--creation de la table new_robots
IF OBJECT_ID('new_robots', 'U') IS NULL
BEGIN
    CREATE TABLE new_robots (
        id INT PRIMARY KEY IDENTITY(1,1),
        date_added DATE NOT NULL DEFAULT GETDATE(),
        numbers_robots_added INT NOT NULL CHECK (numbers_robots_added >= 0),
        id_factorie INT NOT NULL,
        id_robot INT NOT NULL,
        CONSTRAINT FK_NewRobots_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
        CONSTRAINT FK_NewRobots_Robot FOREIGN KEY (id_robot) REFERENCES robots(id)
    );
    PRINT 'Table new_robots créée';
END
ELSE
BEGIN
    PRINT 'Table new_robots existe déjà';
END
GO

--creation de la table parts
IF OBJECT_ID('parts', 'U') IS NULL
BEGIN
    CREATE TABLE parts (
        id INT PRIMARY KEY IDENTITY(1,1),
        name VARCHAR(50) NOT NULL UNIQUE
    );
    PRINT 'Table parts créée';
END
ELSE
BEGIN
    PRINT 'Table parts existe déjà';
END
GO

--creation de la table stocks
IF OBJECT_ID('stocks', 'U') IS NULL
BEGIN
    CREATE TABLE stocks (
        id_factorie INT NOT NULL,
        id INT NOT NULL,
        numbers_of_pieces INT NOT NULL CHECK (numbers_of_pieces >= 0),
        PRIMARY KEY (id_factorie, id),
        CONSTRAINT FK_Stocks_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
        CONSTRAINT FK_Stocks_Part FOREIGN KEY (id) REFERENCES parts(id)
    );
    PRINT 'Table stocks créée';
END
ELSE
BEGIN
    PRINT 'Table stocks existe déjà';
END
GO


--creation de la table suppliers

IF OBJECT_ID('suppliers', 'U') IS NULL
BEGIN
    CREATE TABLE suppliers (
        id INT PRIMARY KEY IDENTITY(1,1),
        name VARCHAR(50) NOT NULL UNIQUE
    );
    PRINT '✓ Table suppliers créée';
END
ELSE
BEGIN
    PRINT '→ Table suppliers existe déjà';
END
GO

--creation de la table new_part
IF OBJECT_ID('new_part', 'U') IS NULL
BEGIN
    CREATE TABLE new_part (
        id INT PRIMARY KEY IDENTITY(1,1),
        count_pieces INT NOT NULL CHECK (count_pieces > 0),
        piece_added DATE NOT NULL DEFAULT GETDATE(),
        id_part INT NOT NULL,
        id_factorie INT NOT NULL,
        id_supplier INT NOT NULL,
        CONSTRAINT FK_NewPart_Supplier FOREIGN KEY (id_supplier) REFERENCES suppliers(id),
        CONSTRAINT FK_NewPart_Part FOREIGN KEY (id_part) REFERENCES parts(id),
        CONSTRAINT FK_NewPart_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id)
    );
    PRINT 'Table new_part créée';
END
ELSE
BEGIN
    PRINT 'Table new_part existe déjà';
END
GO

--creation de la table robot_component 

IF OBJECT_ID('robot_component', 'U') IS NULL
BEGIN
    CREATE TABLE robot_component (
        id INT PRIMARY KEY IDENTITY(1,1),
        id_robot INT NOT NULL,
        id_part INT NOT NULL,
        CONSTRAINT FK_RobotComponent_Robot FOREIGN KEY (id_robot) REFERENCES robots(id),
        CONSTRAINT FK_RobotComponent_Part FOREIGN KEY (id_part) REFERENCES parts(id)
    );
    PRINT 'Table robot_component créée';
END




PRINT 'Base de donnees HUMANROBOT créee avec succes';
GO