USE HUMANROBOT;
GO

-- Vue ALL_WORKERS
IF OBJECT_ID('ALL_WORKERS', 'V') IS NOT NULL
    DROP VIEW ALL_WORKERS;
GO

CREATE VIEW ALL_WORKERS AS
SELECT workers.id, workers.lastname, workers.firstname, workers.age, MAX(contracts.start_contract) AS start_date
FROM workers
INNER JOIN contracts ON workers.id = contracts.id_worker
WHERE contracts.end_contract IS NULL
GROUP BY workers.id, workers.lastname, workers.firstname, workers.age;
GO

-- Vue ALL_WORKERS_ELAPSED
IF OBJECT_ID('ALL_WORKERS_ELAPSED', 'V') IS NOT NULL
    DROP VIEW ALL_WORKERS_ELAPSED;
GO

CREATE VIEW ALL_WORKERS_ELAPSED AS
SELECT id, lastname, firstname, DATEDIFF(DAY, start_date, GETDATE()) AS nb_days_elapsed
FROM ALL_WORKERS;
GO

-- Vue BEST_SUPPLIERS
IF OBJECT_ID('BEST_SUPPLIERS', 'V') IS NOT NULL
    DROP VIEW BEST_SUPPLIERS;
GO

CREATE VIEW BEST_SUPPLIERS AS
SELECT s.name AS supplier, COUNT(*) AS nb_parts
FROM suppliers s
INNER JOIN new_part np ON s.id = np.id_supplier
GROUP BY s.name, s.id
HAVING COUNT(*) > 1000;
GO

-- Vue ROBOTS_FACTORIES
IF OBJECT_ID('ROBOTS_FACTORIES', 'V') IS NOT NULL
    DROP VIEW ROBOTS_FACTORIES;
GO

CREATE VIEW ROBOTS_FACTORIES AS
SELECT f.name AS factory, SUM(sr.numbers_of_robots) AS nb_robots
FROM factories f
INNER JOIN stock_robot sr ON f.id = sr.id_factorie
GROUP BY f.name;
GO