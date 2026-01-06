-- ------------------------------------------------------------
-- HUMANROBOT - data.sql (SQL Server / T-SQL)
-- Insertion des données pour le schema fourni :
-- factories, workers, contracts, robots, stock_robot, new_robots,
-- parts, stocks, new_part, suppliers
-- ------------------------------------------------------------

USE HUMANROBOT;
GO

-- ------------------------------------------------------------
-- RESET (suppression des données en respectant les clés étrangères)
-- ------------------------------------------------------------

DELETE FROM contracts;
DELETE FROM new_robots;
DELETE FROM stock_robot;
DELETE FROM new_part;
DELETE FROM stocks;

DELETE FROM workers;
DELETE FROM robots;
DELETE FROM parts;
DELETE FROM suppliers;
DELETE FROM factories;
GO

-- Reset des IDENTITY
DBCC CHECKIDENT ('contracts', RESEED, 0);
DBCC CHECKIDENT ('new_robots', RESEED, 0);
DBCC CHECKIDENT ('new_part', RESEED, 0);
DBCC CHECKIDENT ('workers', RESEED, 0);
DBCC CHECKIDENT ('robots', RESEED, 0);
DBCC CHECKIDENT ('parts', RESEED, 0);
DBCC CHECKIDENT ('suppliers', RESEED, 0);
DBCC CHECKIDENT ('factories', RESEED, 0);
GO

-- ------------------------------------------------------------
-- factories
-- ------------------------------------------------------------
SET IDENTITY_INSERT factories ON;
INSERT INTO factories (id, name, date_of_creation) VALUES
  (1, 'Usine Paris',   '2020-01-01'),
  (2, 'Usine Caracas', '2020-01-01'),
  (3, 'Usine Beijing', '2020-01-01');
SET IDENTITY_INSERT factories OFF;
GO

-- ------------------------------------------------------------
-- suppliers (non reliée dans ton schéma, mais on garde les données)
-- ------------------------------------------------------------
SET IDENTITY_INSERT suppliers ON;
INSERT INTO suppliers (id, name) VALUES
  (1, 'Optimumx'),
  (2, 'Boston Mimic'),
  (3, 'VCTech Rob');
SET IDENTITY_INSERT suppliers OFF;
GO

-- ------------------------------------------------------------
-- parts
-- ------------------------------------------------------------
SET IDENTITY_INSERT parts ON;
INSERT INTO parts (id, name) VALUES
  (1, 'bras droit'),
  (2, 'bras gauche'),
  (3, 'jambe droit'),
  (4, 'jambe gauche'),
  (5, 'tete'),
  (6, 'buste'),
  (7, 'jetpack');
SET IDENTITY_INSERT parts OFF;
GO

-- ------------------------------------------------------------
-- robots
-- ------------------------------------------------------------
SET IDENTITY_INSERT robots ON;
INSERT INTO robots (id, model) VALUES
  (1, 'Vital Strider'),
  (2, 'Master Sentinel'),
  (3, 'Vanguard Star'),
  (4, 'Grim Angel'),
  (5, 'Amplified Master'),
  (6, 'Phoenix'),
  (7, 'Freedom'),
  (8, 'Coyote'),
  (9, 'Vulture'),
  (10,'Infinity');
SET IDENTITY_INSERT robots OFF;
GO

-- ------------------------------------------------------------
-- workers
-- ------------------------------------------------------------
SET IDENTITY_INSERT workers ON;
INSERT INTO workers (id, firstname, lastname, age) VALUES
  (1,  'Alan',      'Hurst',      61),
  (2,  'Floyd',     'Kelly',      73),
  (3,  'Roger',     'Woodard',    34),
  (4,  'Leon',      'Mullins',    34),
  (5,  'Kim',       'Howe',       20),
  (6,  'Brad',      'Hicks',      21),
  (7,  'Jonathon',  'Owens',      67),
  (8,  'Eddie',     'Strong',     34),
  (9,  'Alec',      'Gamble',     54),
  (10, 'Wesley',    'Harrington', 17),
  (11, 'Marcia',    'Guy',        53),
  (12, 'Theresa',   'McLeod',     68),
  (13, 'Janice',    'Livingston', 51),
  (14, 'Mallory',   'Lancaster',  71),
  (15, 'Bridget',   'McCormick',  29),
  (16, 'Rebekah',   'Burch',      41),
  (17, 'Autumn',    'Holland',    42),
  (18, 'Claire',    'Case',       65),
  (19, 'Billie',    'Waller',     60),
  (20, 'Constance', 'Brock',      31);
SET IDENTITY_INSERT workers OFF;
GO

-- ------------------------------------------------------------
-- contracts (feuille "intervenants") - dates dd/mm/yy -> yyyy-mm-dd
-- ------------------------------------------------------------
SET IDENTITY_INSERT contracts ON;
INSERT INTO contracts (id, start_contract, end_contract, id_factorie, id_worker) VALUES
  (1,  '2014-03-01', '2014-05-07', 1,  1),
  (2,  '2002-06-01', '2003-01-22', 2,  2),
  (3,  '2001-03-01', '2001-07-14', 2,  3),
  (4,  '2001-07-01', '2001-08-12', 2,  4),
  (5,  '2019-12-01', '2020-05-15', 2,  5),
  (6,  '2008-08-01', '2008-10-03', 2,  6),
  (7,  '2001-10-01', '2002-04-14', 2,  7),
  (8,  '2003-10-01', '2004-03-11', 2,  8),
  (9,  '2006-03-01', '2006-05-16', 2,  9),
  (10, '2014-12-01', '2015-07-28', 1, 10),
  (11, '2018-03-01', '2018-05-14', 2, 11),
  (12, '2008-04-01', '2008-11-27', 2, 12),
  (13, '2014-04-01', '2014-08-25', 2, 13),
  (14, '2018-05-01', '2018-10-10', 2, 14),
  (15, '2016-01-01', '2016-02-04', 2, 15),
  (16, '2007-09-01', '2007-10-23', 1, 16),
  (17, '2012-08-01', '2012-12-19', 1, 17),

  (18, '2024-07-01', '2024-10-09', 2,  1),
  (19, '2025-08-01', '2025-12-24', 1,  2),
  (20, '2023-01-01', '2023-06-24', 1,  3),
  (21, '2025-06-01', '2025-11-07', 2,  4),
  (22, '2024-03-01', '2024-04-04', 1,  5),
  (23, '2025-05-01', '2025-08-15', 2,  6),
  (24, '2024-10-01', '2025-01-29', 2,  7),
  (25, '2025-06-01', '2025-08-12', 2,  8),
  (26, '2025-05-01', '2025-10-13', 2,  9),
  (27, '2025-09-01', '2026-02-18', 2, 10),
  (28, '2023-03-01', '2023-08-19', 1, 18),
  (29, '2023-08-01', '2023-09-12', 1, 19),
  (30, '2023-02-01', '2023-04-17', 2, 20),
  (31, '2025-10-01', '2025-12-28', 2, 11),
  (32, '2025-06-01', '2025-12-21', 2, 12),
  (33, '2025-09-01', '2026-01-17', 2, 13),
  (34, '2024-06-01', '2024-10-05', 2, 14),
  (35, '2023-09-01', '2023-12-05', 2, 17);
SET IDENTITY_INSERT contracts OFF;
GO

-- ------------------------------------------------------------
-- new_robots (production) - 1 ligne = (factory, robot, date, quantité)
-- ------------------------------------------------------------
SET IDENTITY_INSERT new_robots ON;
INSERT INTO new_robots (id, date_added, numbers_robots_added, id_factorie, id_robot) VALUES
  -- 2020-01-01
  (1,  '2020-01-01', 29, 1, 1),
  (2,  '2020-01-01', 14, 1, 2),
  (3,  '2020-01-01',  3, 1, 3),
  (4,  '2020-01-01', 34, 1, 4),
  (5,  '2020-01-01', 41, 1, 5),
  (6,  '2020-01-01',  8, 2, 6),
  (7,  '2020-01-01', 25, 2, 7),
  (8,  '2020-01-01',  0, 2, 8),
  (9,  '2020-01-01', 13, 3, 9),
  (10, '2020-01-01',  9, 2,10),

  -- 2020-02-01
  (11, '2020-02-01',  2, 1, 1),
  (12, '2020-02-01', 13, 1, 2),
  (13, '2020-02-01', 32, 1, 3),
  (14, '2020-02-01', 25, 1, 4),
  (15, '2020-02-01',  6, 1, 5),
  (16, '2020-02-01', 34, 2, 6),
  (17, '2020-02-01', 21, 2, 7),
  (18, '2020-02-01', 20, 2, 8),
  (19, '2020-02-01', 38, 3, 9),
  (20, '2020-02-01', 41, 2,10),
  (21, '2020-02-01',  1, 1, 1),

  -- 2020-03-01
  (22, '2020-03-01', 22, 1, 2),
  (23, '2020-03-01', 31, 1, 3),
  (24, '2020-03-01', 15, 1, 4),
  (25, '2020-03-01', 28, 1, 5),
  (26, '2020-03-01',  4, 2, 6),
  (27, '2020-03-01', 39, 2, 7),
  (28, '2020-03-01', 22, 2, 8),
  (29, '2020-03-01', 39, 3, 9),
  (30, '2020-03-01',  3, 2,10),
  (31, '2020-03-01', 31, 1, 1),

  -- 2020-04-01
  (32, '2020-04-01', 26, 1, 2),
  (33, '2020-04-01', 26, 1, 3),
  (34, '2020-04-01', 38, 1, 4),
  (35, '2020-04-01', 17, 1, 5),
  (36, '2020-04-01', 33, 2, 6),
  (37, '2020-04-01', 18, 2, 7),
  (38, '2020-04-01', 14, 2, 8),
  (39, '2020-04-01', 24, 3, 9),
  (40, '2020-04-01', 19, 2,10);
SET IDENTITY_INSERT new_robots OFF;
GO

-- ------------------------------------------------------------
-- stock_robot (stock actuel = somme des productions visibles)
-- ------------------------------------------------------------
INSERT INTO stock_robot (id_factorie, id_robot, numbers_of_robots) VALUES
  -- Usine Paris
  (1, 1,  63),  -- Vital Strider
  (1, 2,  75),  -- Master Sentinel
  (1, 3,  92),  -- Vanguard Star
  (1, 4, 112),  -- Grim Angel
  (1, 5,  92),  -- Amplified Master

  -- Usine Caracas
  (2, 6,  79),  -- Phoenix
  (2, 7, 103),  -- Freedom
  (2, 8,  56),  -- Coyote
  (2,10,  72),  -- Infinity

  -- Usine Beijing
  (3, 9, 114);  -- Vulture
GO

-- ------------------------------------------------------------
-- stocks (pièces en stock par usine)
-- Hypothèse cohérente avec stock_robot :
-- chaque robot nécessite 1 pièce de chaque type
-- ------------------------------------------------------------
-- Total robots par usine:
-- Paris   = 63+75+92+112+92 = 434
-- Caracas = 79+103+56+72    = 310
-- Beijing = 114

INSERT INTO stocks (id_factorie, id, numbers_of_pieces) VALUES
  -- Paris: 434 pièces de chaque type
  (1, 1, 434),
  (1, 2, 434),
  (1, 3, 434),
  (1, 4, 434),
  (1, 5, 434),
  (1, 6, 434),
  (1, 7, 434),

  -- Caracas: 310 pièces de chaque type
  (2, 1, 310),
  (2, 2, 310),
  (2, 3, 310),
  (2, 4, 310),
  (2, 5, 310),
  (2, 6, 310),
  (2, 7, 310),

  -- Beijing: 114 pièces de chaque type
  (3, 1, 114),
  (3, 2, 114),
  (3, 3, 114),
  (3, 4, 114),
  (3, 5, 114),
  (3, 6, 114),
  (3, 7, 114);
GO

-- ------------------------------------------------------------
-- new_part
-- Ton schéma ne relie pas aux suppliers (pas de id_supplier),
-- donc on enregistre ici une "livraison initiale" de pièces par usine,
-- alignée sur le stock initial ci-dessus.
-- ------------------------------------------------------------
SET IDENTITY_INSERT new_part ON;
INSERT INTO new_part (id, count_pieces, piece_added, id_part, id_factorie) VALUES
  -- Paris
  (1, 434, '2020-01-01', 1, 1),
  (2, 434, '2020-01-01', 2, 1),
  (3, 434, '2020-01-01', 3, 1),
  (4, 434, '2020-01-01', 4, 1),
  (5, 434, '2020-01-01', 5, 1),
  (6, 434, '2020-01-01', 6, 1),
  (7, 434, '2020-01-01', 7, 1),

  -- Caracas
  (8, 310, '2020-01-01', 1, 2),
  (9, 310, '2020-01-01', 2, 2),
  (10,310, '2020-01-01', 3, 2),
  (11,310, '2020-01-01', 4, 2),
  (12,310, '2020-01-01', 5, 2),
  (13,310, '2020-01-01', 6, 2),
  (14,310, '2020-01-01', 7, 2),

  -- Beijing
  (15,114, '2020-01-01', 1, 3),
  (16,114, '2020-01-01', 2, 3),
  (17,114, '2020-01-01', 3, 3),
  (18,114, '2020-01-01', 4, 3),
  (19,114, '2020-01-01', 5, 3),
  (20,114, '2020-01-01', 6, 3),
  (21,114, '2020-01-01', 7, 3);
SET IDENTITY_INSERT new_part OFF;
GO