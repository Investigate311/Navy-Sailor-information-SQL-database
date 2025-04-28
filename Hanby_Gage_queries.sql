CREATE DATABASE Hanby_Gage_db
--locations on the ship. Very broad and could be more specific
CREATE TABLE Locations (
	Loc_ID INT NOT NULL,
	Loc_Name char(15) NOT NULL,
	CONSTRAINT LOCATION_PK PRIMARY KEY (Loc_ID)
);
--Departments in the ship
CREATE TABLE Departments (
    Dep_ID INT NOT NULL,
	Dep_Loc_ID INT NOT NULL,
	Ship_Type char(3) NOT NULL,
	Ship_Hull_Number int NOT NULL,
    Dep_Name CHAR(20) NOT NULL,
    Max_Occupancy INT NOT NULL,
    Min_Occupancy INT NOT NULL,
    Current_Occupancy INT NOT NULL,
	CONSTRAINT DEPARTMENT_PK PRIMARY KEY (Dep_ID),
	CONSTRAINT DEPARTMENT_FK FOREIGN KEY (Dep_Loc_ID) REFERENCES Locations(Loc_ID)
);
--Division on the ship
CREATE TABLE Divisions (
    Div_Name CHAR(10) NOT NULL,
    Dep_ID INT NOT NULL,
    Max_Occupancy INT NOT NULL,
    Min_Occupancy INT NOT NULL,
    Current_Occupancy INT NOT NULL,
    CONSTRAINT DIVISIONS_PK PRIMARY KEY (Div_Name, Dep_ID),
    CONSTRAINT DIVISIONS_FK FOREIGN KEY (Dep_ID) REFERENCES Departments(Dep_ID)
);
--Workstations on the ship
CREATE TABLE Workstations (
    Workstation_ID INT NOT NULL,
    Workstation_Name CHAR(20) NOT NULL,
    Division_Name CHAR(10) NOT NULL,
    Dep_ID INT NOT NULL,
	CONSTRAINT WORKSTATIONS_PK PRIMARY KEY (Workstation_ID),
    CONSTRAINT WORKSTATIONS_FK FOREIGN KEY (Division_Name, Dep_ID) REFERENCES Divisions(Div_Name, Dep_ID)
);
--Paygrades that defines the ranks and what they are paid. Also accounts for leadership status
CREATE TABLE Paygrades (
    Paygrade_Designation CHAR(3) NOT NULL,
    Pay INT NOT NULL,
    Leader BIT NOT NULL
	CONSTRAINT PAYGRADES_PK PRIMARY KEY (Paygrade_Designation)
);
--Berthing areas on the ship
CREATE TABLE Berthing (
    Berthing_Number INT NOT NULL,
    Dep_ID INT NOT NULL,
    Max_Occupancy INT NOT NULL,
    Current_Occupancy INT NULL,
    CONSTRAINT BERTHING_PK PRIMARY KEY (Berthing_Number, Dep_ID),
    CONSTRAINT BERTHING_FK FOREIGN KEY (Dep_ID) REFERENCES Departments(Dep_ID)
);

--Equipments in a workstation
CREATE TABLE Equipments (
	Workstation_ID INT NOT NULL,
    NIIN CHAR(12) NOT NULL,
    Broken_Status BIT NOT NULL,
    EMCON_Condition INT NULL,
    Cost INT NOT NULL
	CONSTRAINT EQUIPMENTS_PK PRIMARY KEY (NIIN, Workstation_ID),
	CONSTRAINT EQUIPMENTS_FK FOREIGN KEY (Workstation_ID) REFERENCES Workstations(Workstation_ID)
);
--Fleet priorities for a certain area
CREATE TABLE Fleet_Priorities (
    Priority_ID INT NOT NULL,
    Priority_Level CHAR(20) NOT NULL
	CONSTRAINT FLEET_PRIORITIES_PK PRIMARY KEY (Priority_ID)
);
--fleets in the world
CREATE TABLE Fleets (
    Fleet_Number INT NOT NULL,
    Fleet_Area CHAR(50) NOT NULL,
    Priority_ID INT NOT NULL,
	CONSTRAINT FLEET_PK PRIMARY KEY (Fleet_Number),
    CONSTRAINT FLEET_FK FOREIGN KEY (Priority_ID) REFERENCES Fleet_Priorities(Priority_ID)
);
--Ships in a fleet
CREATE TABLE Ships (
    Ship_Type CHAR(3) NOT NULL,
    Hull_Number INT NOT NULL,
	Ship_Fleet INT NOT NULL,
    CONSTRAINT SHIPS_PK PRIMARY KEY (Ship_Type, Hull_Number),
	CONSTRAINT SHIPS_FK FOREIGN KEY (Ship_Fleet) REFERENCES Fleets(Fleet_Number)
);
--Different raft types
CREATE TABLE Raft_Types (
    Raft_Model_ID INT NOT NULL,
    Max_Occupancy INT NOT NULL,
	CONSTRAINT RAFT_TYPE_PK PRIMARY KEY (Raft_Model_ID)
);
--Different rafts on the ship
CREATE TABLE Rafts (
    Raft_Number INT NOT NULL,
    Raft_Type INT NOT NULL,
    Current_Occupancy INT NOT NULL,
	CONSTRAINT RAFTS_PK PRIMARY KEY (Raft_Number),
    CONSTRAINT RAFTS_FK FOREIGN KEY (Raft_Type) REFERENCES Raft_Types(Raft_Model_ID)
);
--GQ stations for battle stations
CREATE TABLE GQ_Station (
    GQ_Name CHAR(30) NOT NULL,
    Workstation_ID INT NOT NULL,
    Manned_Status BIT NOT NULL,
    CONSTRAINT GQ_PK PRIMARY KEY (GQ_Name, Workstation_ID),
    CONSTRAINT GQ_FK_Workstation FOREIGN KEY (Workstation_ID) REFERENCES Workstations(Workstation_ID)
);

--Education codes for sailors
CREATE TABLE NECs (
    NEC_Serial INT NOT NULL,
    NEC_Designation CHAR(10) NOT NULL,
	NEC_Description CHAR(50) NOT NULL,
	CONSTRAINT NEC_PK PRIMARY KEY (NEC_Serial)
);
--DC lockers for sailors. Not directly contrained with GQ stations
CREATE TABLE DC_Lockers (
    Locker_Number INT NOT NULL,
    Max_Occupancy INT NOT NULL,
    Min_Occupancy INT NOT NULL,
    Current_Occupancy INT NOT NULL,
	CONSTRAINT DC_LOCKER_PK PRIMARY KEY (Locker_Number)
);
--Different chow sections
CREATE TABLE Chows (
    Rotation_Number INT NOT NULL,
    Max_Occupancy INT NOT NULL,
	CONSTRAINT CHOW_PK PRIMARY KEY (Rotation_Number)
);

--Different duty sections
CREATE TABLE Duty_Sections (
    Section_Number INT NOT NULL,
    Min_Occupancy INT NOT NULL,
    Current_Occupancy INT NOT NULL,
	CONSTRAINT DUTY_SECTIONS_PK PRIMARY KEY (Section_Number)
);

--Sailors table
CREATE TABLE Sailors (
    DOD_ID INT NOT NULL,
    Last_Name CHAR(20) NOT NULL,
    First_Name CHAR(20) NOT NULL,
    Date_Of_Birth CHAR(10) NOT NULL,
    Paygrade CHAR(3) NOT NULL,
    Days_Stationed INT NOT NULL,
    Div_Name CHAR(10) NOT NULL,
    Dep_ID INT NOT NULL,
    TAD_Status BIT NOT NULL,
    Raft_Number INT NOT NULL,
    DC_Locker INT NOT NULL,
    Brig_Status BIT NOT NULL,
	Chow_Number INT NOT NULL,
	CONSTRAINT SAILOR_PK PRIMARY KEY (DOD_ID),
    CONSTRAINT SAILOR_FK_1 FOREIGN KEY (Paygrade) REFERENCES Paygrades(Paygrade_Designation),
    CONSTRAINT SAILOR_FK_2 FOREIGN KEY (Div_Name, Dep_ID) REFERENCES Divisions(Div_Name, Dep_ID),
    CONSTRAINT SAILOR_FK_3 FOREIGN KEY (Raft_Number) REFERENCES Rafts(Raft_Number),
	CONSTRAINT SAILOR_FK_4 FOREIGN KEY (Dep_ID) REFERENCES Departments(Dep_ID),
	CONSTRAINT SAILOR_FK_6 FOREIGN KEY (DC_Locker) REFERENCES DC_Lockers(Locker_Number),
	CONSTRAINT SAILOR_FK_7 FOREIGN KEY (Chow_Number) REFERENCES Chows(Rotation_Number)
);
--Qualifications sailors have
CREATE TABLE Sailor_Qualifications (
    DOD_ID INT NOT NULL,
    Watch_Qualification INT NOT NULL,
    CONSTRAINT QUAL_FK FOREIGN KEY (DOD_ID) REFERENCES Sailors(DOD_ID)
);
--Duty section a sailor is assigned to
CREATE TABLE Sailor_Duty_Sections (
    DOD_ID INT NOT NULL,
    Section_Number INT NOT NULL,
    CONSTRAINT SAILOR_DUTY_FK_1 FOREIGN KEY (DOD_ID) REFERENCES Sailors(DOD_ID)
);
--NEC's a sailor has
CREATE TABLE Sailor_NECs (
    DOD_ID INT NOT NULL,
    NEC_Serial INT NOT NULL,
    CONSTRAINT SAILOR_NEC_FK_1 FOREIGN KEY (DOD_ID) REFERENCES Sailors(DOD_ID)
);

INSERT Duty_Sections (Section_Number, Min_Occupancy, Current_Occupancy) VALUES
(1, 50, 150),
(2, 50, 201),
(3, 50, 198),
(4, 50, 203),
(5, 50, 67),
(6, 20, 88),
(7, 20, 100);
INSERT NECs (NEC_Serial, NEC_Designation, NEC_Description) VALUES 
(1, 'C1000', 'Engine Mechanic'),
(2, 'C1311', 'Botswain'),
(3, 'C1987', 'Flag Communicator'),
(4, 'C2345', 'Sentry'),
(5, 'C0001', 'Radio SME'),
(6, 'C5656', 'Fire Response'),
(7, 'C8888', 'Combatant Spotting');
INSERT Chows (Rotation_Number, Max_Occupancy) VALUES 
(1, 5000),
(2, 1000);
INSERT Raft_Types (Raft_Model_ID, Max_Occupancy) VALUES
(1, 10),
(2, 25),
(3, 50);
INSERT Rafts (Raft_Number, Raft_Type, Current_Occupancy) VALUES 
(1, 1, 8),
(2, 1, 9),
(3, 2, 16),
(4, 3, 50);
-- Insert into Locations
INSERT INTO Locations (Loc_ID, Loc_Name) VALUES
(1, 'FWD'),
(2, 'MIDSHIP'),
(3, 'AFT'),
(4, 'FRONT ISLAND'),
(5, 'REAR ISLAND');

INSERT DC_Lockers (Locker_Number, Max_Occupancy, Min_Occupancy, Current_Occupancy) VALUES
(1, 20, 5, 15),
(2, 30, 10, 21),
(3, 40, 10, 11),
(4, 50, 15, 20),
(5, 60, 20, 56);
-- Insert into Departments
INSERT INTO Departments (Dep_ID, Dep_Loc_ID, Ship_Type, Ship_Hull_Number, Dep_Name, Max_Occupancy, Min_Occupancy, Current_Occupancy) VALUES
(1, 3, 'CVN', 54, 'Engineering', 100, 50, 75),
(2, 2, 'DDG', 51, 'Operations', 80, 40, 60),
(3, 3, 'DDG', 51, 'Logistics', 90, 45, 70),
(4, 1, 'DDG', 51, 'Medical', 70, 35, 55),
(5, 4, 'CVN', 54, 'Navigation', 85, 40, 65),
(6, 1, 'CVN', 54, 'Weapons', 95, 45, 80),
(7, 5, 'LCS', 57, 'Communications', 75, 35, 50),
(8, 1, 'LCS', 57, 'Training', 110, 50, 90),
(9, 2, 'LCS', 57, 'Security', 120, 60, 100),
(10, 3, 'LCS', 57, 'Legal', 10, 1, 11);

-- Insert into Divisions
INSERT INTO Divisions (Div_Name, Dep_ID, Max_Occupancy, Min_Occupancy, Current_Occupancy) VALUES
('ENG01', 1, 50, 20, 35),
('OPS1', 2, 40, 15, 30),
('SUPPO01', 3, 45, 18, 35),
('ME01', 4, 35, 10, 25),
('NAV01', 5, 40, 15, 30),
('WEPS01', 6, 50, 20, 40),
('CC01', 7, 30, 10, 20),
('TRAINO01', 8, 25, 10, 18),
('SEC01', 9, 55, 25, 45),
('LEGAL', 10, 10, 1, 11);


-- Insert into Workstations
INSERT INTO Workstations (Workstation_ID, Workstation_Name, Division_Name, Dep_ID) VALUES
(1, 'Engine Room', 'ENG01', 1),
(2, 'Operations', 'OPS1', 2),
(3, 'General Supply', 'SUPPO01', 3),
(4, 'Medical Bay', 'ME01', 4),
(5, 'Navigations ', 'NAV01', 5),
(6, 'Armory', 'WEPS01', 6),
(7, 'Radio', 'CC01', 7),
(8, 'Training', 'TRAINO01', 8),
(9, 'Security Center', 'SEC01', 9),
(10, 'Legal Center', 'LEGAL', 10);

INSERT GQ_Station (GQ_Name, Workstation_ID, Manned_Status) VALUES
('Engine 1', 1, 1),
('Spotter 1', 2, 1),
('Spotter 2', 3, 1),
('DC Watcher 1', 4, 1),
('Engine 2', 5, 1),
('Spotter 3', 6, 0),
('Spotter 4', 7, 1),
('Engine 3', 8, 1),
('DC Watcher 2', 9, 1),
('DC Watcher 3', 10, 0);
-- Insert into Paygrades
INSERT INTO Paygrades (Paygrade_Designation, Pay, Leader) VALUES
('E1', 2000, 0),
('E2', 2200, 0),
('E3', 2500, 0),
('E4', 2800, 0),
('E5', 3100, 1),
('E6', 3500, 1),
('E7', 4000, 1),
('E8', 4500, 1),
('E9', 5000, 1),
('O1', 5500, 1);

-- Insert into Berthing
INSERT INTO Berthing (Berthing_Number, Dep_ID, Max_Occupancy, Current_Occupancy) VALUES
(1, 1, 20, 15),
(2, 2, 18, 14),
(3, 3, 25, 20),
(4, 4, 15, 10),
(5, 5, 22, 18),
(6, 6, 30, 25),
(7, 7, 17, 12),
(8, 8, 20, 16),
(9, 9, 35, 28),
(10, 10, 40, 35);

-- Insert into Equipments
INSERT INTO Equipments (Workstation_ID, NIIN, Broken_Status, EMCON_Condition, Cost) VALUES
(1, '56-789-0123', 0, 3, 5000),
(2, '54-321-6789', 1, 2, 4000),
(2, '89-012-3456', 0, 1, 6000),
(3, '21-098-7654', 1, 3, 7000),
(4, '33-444-5555', 0, 2, 5500),
(4, '88-999-0000', 1, 1, 6500),
(1, '74-159-2638', 0, 3, 8000),
(2, '41-753-6985', 0, 2, 9000),
(5, '26-847-3102', 1, 1, 10000),
(4, '59-468-2057', 0, 3, 7500);

INSERT INTO Fleet_Priorities (Priority_ID, Priority_Level) VALUES
(1, 'ROUTINE'),
(2, 'ELEVATED'),
(3, 'CRITICAL'),
(4, 'MANDATORY'),
(5, 'FLASH');
-- Insert into Fleets
INSERT INTO Fleets (Fleet_Number, Fleet_Area, Priority_ID) VALUES
(1, 'Atlantic', 2),
(2, 'Pacific', 2),
(3, 'Mediterranean', 3),
(4, 'Indian Ocean', 3),
(5, 'Arctic', 1),
(6, 'South China Sea', 4),
(7, 'Caribbean', 2),
(8, 'Persian Gulf', 4),
(9, 'Baltic Sea', 1),
(10, 'Cyber', 5);

-- Insert into Ships
INSERT INTO Ships (Ship_Type, Hull_Number, Ship_Fleet) VALUES
('DDG', 51, 1),
('CG', 52, 2),
('LHD', 53, 3),
('CVN', 54, 4),
('SSN', 55, 5),
('SSB', 56, 6),
('LCS', 57, 7),
('PC', 58, 8),
('FFG', 59, 9),
('AOE', 60, 10),
('CVN', 8, 4);

-- Insert into Sailors
INSERT INTO Sailors (DOD_ID, Last_Name, First_Name, Date_Of_Birth, Paygrade, Days_Stationed, Div_Name, Dep_ID, TAD_Status, Raft_Number, DC_Locker, Brig_Status, Chow_Number) VALUES
(1001, 'Smith', 'John', '1990-01-01', 'E5', 100, 'ENG01', 1, 0, 1, 1, 0, 1),
(1002, 'Johnson', 'David', '1991-02-02', 'E4', 120, 'OPS1', 2, 1, 2, 2, 0, 1),
(1003, 'Brown', 'Michael', '1992-03-03', 'E3', 90, 'SUPPO01', 3, 0, 3, 3, 0, 2),
(1004, 'Williams', 'Chris', '1993-04-04', 'E2', 80, 'ME01', 4, 1, 4, 4, 1, 2);

INSERT Sailor_Qualifications(DOD_ID, Watch_Qualification) VALUES
(1001, 301),
(1002, 305),
(1003, 305),
(1004, 309);

INSERT Sailor_NECs (DOD_ID, NEC_Serial) VALUES 
(1001, 1),
(1002, 1),
(1003, 3),
(1004, 2);
INSERT Sailor_Duty_Sections (DOD_ID, Section_Number) VALUES 
(1001, 1),
(1002, 2),
(1003, 2),
(1004, 4);

SELECT * FROM Sailors
WHERE DOD_ID = 1001;

SELECT * FROM Equipments
WHERE NIIN = '56-789-0123';

SELECT * FROM Equipments
WHERE Broken_Status = 1;

SELECT DOD_ID, First_Name, Last_Name, Brig_Status FROM Sailors
WHERE Brig_Status = 1;

SELECT Sailors.DOD_ID, Sailors.First_Name, Sailors.Last_Name, Rafts.Raft_Number, Rafts.Current_Occupancy FROM Sailors
JOIN Rafts ON Sailors.Raft_Number = Rafts.Raft_Number
WHERE Sailors.DOD_ID = 1001;

SELECT Section_Number, COUNT(*) AS Sailor_Count FROM Sailors
JOIN Sailor_Duty_Sections ON Sailors.DOD_ID = Sailor_Duty_Sections.DOD_ID
GROUP BY Section_Number;

SELECT Section_Number, COUNT(*) AS Sailor_Count FROM Sailors
JOIN Sailor_Duty_Sections ON Sailors.DOD_ID = Sailor_Duty_Sections.DOD_ID
WHERE Sailor_Duty_Sections.Section_Number = 1
GROUP BY Section_Number;
-- Analytic
SELECT DOD_ID, First_Name, Last_Name, Paygrade, Days_Stationed FROM Sailors
WHERE Paygrade IN ('E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9')  
  AND Days_Stationed > 50;

SELECT TOP 1 Berthing_Number, Current_Occupancy, Max_Occupancy FROM Berthing
ORDER BY Current_Occupancy DESC;

SELECT DISTINCT Divisions.Div_Name FROM Sailors
JOIN Divisions ON Sailors.Div_Name = Divisions.Div_Name
WHERE Sailors.Days_Stationed < 100;

SELECT TOP 1 Divisions.Div_Name, COUNT(*) AS Equipment_Count FROM Equipments
JOIN Workstations ON Equipments.Workstation_ID = Workstations.Workstation_ID
JOIN Divisions ON Workstations.Division_Name = Divisions.Div_Name
GROUP BY Divisions.Div_Name
ORDER BY Equipment_Count DESC

SELECT TOP 1 Fleets.Fleet_Number, COUNT(*) AS Ship_Count FROM Ships
JOIN Fleets ON Ships.Ship_Fleet = Fleets.Fleet_Number
GROUP BY Fleets.Fleet_Number
ORDER BY Ship_Count DESC;