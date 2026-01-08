-- SQL MARIA DB -- 

DROP DATABASE IF EXISTS HUMANROBOT;
CREATE DATABASE HUMANROBOT;
USE HUMANROBOT;

-- Table workers
CREATE TABLE workers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

-- Table factories
CREATE TABLE factories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    date_of_creation DATE NOT NULL
);

-- Table contracts
CREATE TABLE contracts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    start_contract DATE NOT NULL,
    end_contract DATE NULL,
    id_factorie INT NOT NULL,
    id_worker INT NOT NULL,
    CONSTRAINT FK_Contracts_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
    CONSTRAINT FK_Contracts_Worker FOREIGN KEY (id_worker) REFERENCES workers(id),
    CONSTRAINT CHK_Contracts_Dates CHECK (end_contract IS NULL OR end_contract >= start_contract)
);

-- Table robots
CREATE TABLE robots (
    id INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL UNIQUE
);

-- Table stock_robot
CREATE TABLE stock_robot (
    id_factorie INT NOT NULL,
    id_robot INT NOT NULL,
    numbers_of_robots INT NOT NULL CHECK (numbers_of_robots >= 0),
    PRIMARY KEY (id_factorie, id_robot),
    CONSTRAINT FK_StockRobot_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
    CONSTRAINT FK_StockRobot_Robot FOREIGN KEY (id_robot) REFERENCES robots(id)
);

-- Table new_robots
CREATE TABLE new_robots (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date_added DATE NOT NULL DEFAULT (CURRENT_DATE),
    numbers_robots_added INT NOT NULL CHECK (numbers_robots_added >= 0),
    id_factorie INT NOT NULL,
    id_robot INT NOT NULL,
    CONSTRAINT FK_NewRobots_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
    CONSTRAINT FK_NewRobots_Robot FOREIGN KEY (id_robot) REFERENCES robots(id)
);

-- Table parts
CREATE TABLE parts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Table stocks
CREATE TABLE stocks (
    id_factorie INT NOT NULL,
    id INT NOT NULL,
    numbers_of_pieces INT NOT NULL CHECK (numbers_of_pieces >= 0),
    PRIMARY KEY (id_factorie, id),
    CONSTRAINT FK_Stocks_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id),
    CONSTRAINT FK_Stocks_Part FOREIGN KEY (id) REFERENCES parts(id)
);

-- Table new_part
CREATE TABLE new_part (
    id INT PRIMARY KEY AUTO_INCREMENT,
    count_pieces INT NOT NULL CHECK (count_pieces > 0),
    piece_added DATE NOT NULL DEFAULT (CURRENT_DATE),
    id_part INT NOT NULL,
    id_factorie INT NOT NULL,
    CONSTRAINT FK_NewPart_Part FOREIGN KEY (id_part) REFERENCES parts(id),
    CONSTRAINT FK_NewPart_Factory FOREIGN KEY (id_factorie) REFERENCES factories(id)
);

-- Table suppliers
CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Table robot_component
CREATE TABLE robot_component (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_robot INT NOT NULL,
    id_part INT NOT NULL,
    CONSTRAINT FK_RobotComponent_Robot FOREIGN KEY (id_robot) REFERENCES robots(id),
    CONSTRAINT FK_RobotComponent_Part FOREIGN KEY (id_part) REFERENCES parts(id)
);