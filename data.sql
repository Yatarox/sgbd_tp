USE HUMANROBOT;
GO

-- Insertion des usines
INSERT INTO factories (name, date_of_creation) VALUES
('Usine Paris', '2000-01-01'),
('Usine Caracas', '2005-06-15'),
('Usine Beijing', '2010-03-20');
GO

-- Insertion des fournisseurs (DOIT être fait avant les pièces)
INSERT INTO suppliers (name) VALUES
('Optimux'),
('Boston Mimics'),
('VCTech Robo');
GO

-- Insertion des robots
INSERT INTO robots (model) VALUES
('Vital Strider'),
('Master Sentinel'),
('Vanguard Stall'),
('Grim Angel'),
('Amplified Mast'),
('Phoenix'),
('Freedom'),
('Coyote'),
('Vulture'),
('Infinity');
GO

-- Insertion des pièces détachées (avec leurs fournisseurs)
-- Optimux (id=1), Boston Mimics (id=2), VCTech Robo (id=3)
INSERT INTO parts (name, id_supplier) VALUES
('bras droit', 1),      -- Optimux
('bras gauche', 2),     -- Boston Mimics
('jambe droit', 3),     -- VCTech Robo
('jambe gauche', 1),    -- Optimux
('tete', 2),            -- Boston Mimics
('buste', 3),           -- VCTech Robo
('jetpack', 1);         -- Optimux
GO

-- Insertion des composants de robots (relation robot-pièce)
-- Chaque robot a plusieurs pièces
INSERT INTO robot_component (id_robot, id_part) VALUES
-- Vital Strider (id=1) : bras droit, bras gauche, jambe droit, jambe gauche, tete, buste
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
-- Master Sentinel (id=2) : toutes les pièces + jetpack
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7),
-- Vanguard Stall (id=3) : bras droit, bras gauche, jambe droit, jambe gauche, tete
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5),
-- Grim Angel (id=4) : toutes les pièces
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6),
-- Amplified Mast (id=5) : toutes les pièces + jetpack
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 6), (5, 7),
-- Phoenix (id=6) : bras droit, bras gauche, jambe droit, jambe gauche, tete, buste
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6),
-- Freedom (id=7) : toutes les pièces
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6),
-- Coyote (id=8) : bras droit, bras gauche, jambe droit, jambe gauche
(8, 1), (8, 2), (8, 3), (8, 4),
-- Vulture (id=9) : toutes les pièces + jetpack
(9, 1), (9, 2), (9, 3), (9, 4), (9, 5), (9, 6), (9, 7),
-- Infinity (id=10) : toutes les pièces
(10, 1), (10, 2), (10, 3), (10, 4), (10, 5), (10, 6);
GO

-- Insertion des travailleurs
INSERT INTO workers (firstname, lastname, age) VALUES
('Alan', 'Hurst', 61),
('Floyd', 'Kelly', 73),
('Roger', 'Woodard', 34),
('Leon', 'Mullins', 34),
('Kim', 'Howe', 20),
('Brad', 'Hicks', 21),
('Jonathon', 'Owens', 67),
('Eddie', 'Strong', 34),
('Alec', 'Gamble', 54),
('Wesley', 'Harrington', 17),
('Marcia', 'Guy', 53),
('Theresa', 'McLeod', 68),
('Janice', 'Livingston', 51),
('Mallory', 'Lancaster', 71);
GO

-- Insertion des contrats
INSERT INTO contracts (start_contract, end_contract, id_factorie, id_worker) VALUES
('2014-03-01', '2014-05-07', 1, 1),
('2002-06-01', '2003-01-22', 1, 2),
('2001-03-01', '2001-07-14', 1, 3),
('2001-07-01', '2001-08-12', 1, 4),
('2019-12-01', '2020-05-15', 1, 5),
('2008-08-01', '2008-10-03', 1, 6),
('2001-10-01', '2002-04-14', 1, 7),
('2003-10-01', '2004-03-11', 1, 8),
('2006-03-01', '2006-05-16', 1, 9),
('2014-12-01', '2015-07-28', 1, 10),
('2018-03-01', '2018-05-14', 1, 11),
('2008-04-01', '2008-11-27', 1, 12),
('2014-04-01', '2014-08-25', 2, 13),
('2018-05-01', '2018-10-10', 2, 14);
GO

-- Insertion des stocks de robots (valeurs initiales)
INSERT INTO stock_robot (id_factorie, id_robot, numbers_of_robots) VALUES
(1, 1, 29),  -- Usine Paris, Vital Strider
(1, 2, 14),  -- Usine Paris, Master Sentinel
(1, 3, 3),   -- Usine Paris, Vanguard Stall
(1, 4, 34),  -- Usine Paris, Grim Angel
(1, 5, 41),  -- Usine Paris, Amplified Mast
(2, 6, 8),   -- Usine Caracas, Phoenix
(2, 7, 25),  -- Usine Caracas, Freedom
(2, 8, 0),   -- Usine Caracas, Coyote
(2, 9, 13),  -- Usine Caracas, Vulture
(2, 10, 9),  -- Usine Caracas, Infinity
(3, 9, 2),   -- Usine Beijing, Vulture
(3, 10, 13); -- Usine Beijing, Infinity
GO

-- Ajout de nouveaux robots via new_robots (les triggers mettront à jour automatiquement les stocks)
-- Ces insertions simulent les mises à jour de stock visibles dans les données
-- Note: La contrainte CHECK empêche les valeurs négatives, donc on ajuste les stocks initiaux
INSERT INTO new_robots (date_added, numbers_robots_added, id_factorie, id_robot) VALUES
('2020-01-02', 3, 1, 1),   -- +3 Vital Strider à Paris (29 -> 32)
('2020-01-02', 11, 1, 2),  -- +11 Master Sentinel à Paris (14 -> 25)
('2020-01-02', 9, 2, 7),   -- +9 Freedom à Caracas (25 -> 34)
('2020-01-02', 19, 3, 9);  -- +19 Vulture à Beijing (2 -> 21)
GO

-- Mise à jour manuelle du stock pour Phoenix (réduction de 8 à 6)
-- On ne peut pas utiliser de valeur négative dans new_robots, donc on met à jour directement
UPDATE stock_robot 
SET numbers_of_robots = 6 
WHERE id_factorie = 2 AND id_robot = 6;
GO

-- Insertion des stocks de pièces (exemple basé sur les données)
INSERT INTO stocks (id_factorie, id, numbers_of_pieces) VALUES
(1, 1, 50),  -- Usine Paris, bras droit
(1, 2, 45),  -- Usine Paris, bras gauche
(1, 3, 60),  -- Usine Paris, jambe droit
(1, 4, 55),  -- Usine Paris, jambe gauche
(1, 5, 30),  -- Usine Paris, tete
(1, 6, 40),  -- Usine Paris, buste
(1, 7, 20),  -- Usine Paris, jetpack
(2, 1, 35),  -- Usine Caracas, bras droit
(2, 2, 30),  -- Usine Caracas, bras gauche
(2, 3, 40),  -- Usine Caracas, jambe droit
(2, 4, 35),  -- Usine Caracas, jambe gauche
(2, 5, 25),  -- Usine Caracas, tete
(2, 6, 30),  -- Usine Caracas, buste
(2, 7, 15),  -- Usine Caracas, jetpack
(3, 1, 25),  -- Usine Beijing, bras droit
(3, 2, 20),  -- Usine Beijing, bras gauche
(3, 3, 30),  -- Usine Beijing, jambe droit
(3, 4, 25),  -- Usine Beijing, jambe gauche
(3, 5, 15),  -- Usine Beijing, tete
(3, 6, 20),  -- Usine Beijing, buste
(3, 7, 10);  -- Usine Beijing, jetpack
GO

PRINT 'Donnees inserees avec succes';
GO

