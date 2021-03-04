CREATE DATABASE Turism;
USE Turism;

CREATE TABLE Resort (
    ResortId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Nume nvarchar(MAX),
    NumarStele int,
    Rating int
);

CREATE TABLE Cabana (
    CabanaId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Nume nvarchar(MAX),
    ResortId int,
    NrLocuri int,
    PretNoapte int,
    
    FOREIGN KEY(ResortId) REFERENCES Resort(ResortId)
);

CREATE TABLE Client (
    ClientId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Nume nvarchar(MAX),
    DataNasterii date,
    TaraOrigine nvarchar(MAX)
);

CREATE TABLE Activitate (
    ActivitateId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Nume nvarchar(MAX),
    Pret int,
    Descriere nvarchar(MAX),
);

CREATE TABLE Categorie (
    CategorieId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Nume nvarchar(MAX)
);

CREATE TABLE CategoriiActivitati (
    CategoriiActivitatiId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    CategorieId int,
    ActivitateId int,
    
    FOREIGN KEY(ActivitateId) REFERENCES Activitate(ActivitateId),
    FOREIGN KEY(CategorieId) REFERENCES Categorie(CategorieId)
);

CREATE TABLE Cazare (
    CazareId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    ClientId int,
    CabanaId int,
    DataCazarii date,
    NrNopti int,
    
    FOREIGN KEY(ClientId) REFERENCES Client(ClientId),
    FOREIGN KEY(CabanaId) REFERENCES Cabana(CabanaId)
);

CREATE TABLE ActivitateClient (
    ActivitateClient int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    ClientId int,
    ActivitateId int,
    DataActivitatii date,
    OraActivitatii time,
    
    FOREIGN KEY(ActivitateId) REFERENCES Activitate(ActivitateId),
    FOREIGN KEY(ClientId) REFERENCES Client(ClientId)
);

INSERT INTO Cabana (Nume, ResortId, NrLocuri, PretNoapte) VALUES ('7 Brazi', 1, 50, 100)
INSERT INTO Cabana (Nume, ResortId, NrLocuri, PretNoapte) VALUES ('Piticilor', 3, 2, 90)
INSERT INTO Cabana (Nume, ResortId, NrLocuri, PretNoapte) VALUES ('Steluta', 2, 10, 75)

INSERT INTO Resort (Nume, NumarStele, Rating) VALUES ('Resort A', 5, 10)
INSERT INTO Resort (Nume, NumarStele, Rating) VALUES ('Resort B', 4, 9)
INSERT INTO Resort (Nume, NumarStele, Rating) VALUES ('Resort C', 3, 8)

INSERT INTO Client (Nume, DataNasterii, TaraOrigine) VALUES ('Ionel Popescu', '03-22-1992', 'Romania')
INSERT INTO Client (Nume, DataNasterii, TaraOrigine) VALUES ('Maria Pop', '10-03-1994', 'Romania')
INSERT INTO Client (Nume, DataNasterii, TaraOrigine) VALUES ('Ana Pica', '04-22-1993', 'Romania')

INSERT INTO Cazare (ClientId, CabanaId, DataCazarii, NrNopti) VALUES (3, 3, '01-01-2020', 3)
INSERT INTO Cazare (ClientId, CabanaId, DataCazarii, NrNopti) VALUES (5, 1, '04-01-2020', 2)
INSERT INTO Cazare (ClientId, CabanaId, DataCazarii, NrNopti) VALUES (6, 2, '03-01-2020', 5)
INSERT INTO Cazare (ClientId, CabanaId, DataCazarii, NrNopti) VALUES (3, 1, '01-01-2020', 3)

INSERT INTO Categorie (Nume) VALUES ('sport')
INSERT INTO Categorie (Nume) VALUES ('relaxare')

INSERT INTO Activitate (Nume, Pret, Descriere) VALUES ('spa', 200, 'super relaxant')
INSERT INTO Activitate (Nume, Pret, Descriere) VALUES ('aventura park', 150, 'adrenalina')
INSERT INTO Activitate (Nume, Pret, Descriere) VALUES ('tiroliana', 100, 'adrenalina')

INSERT INTO CategoriiActivitati (CategorieId, ActivitateId) VALUES (1, 2)
INSERT INTO CategoriiActivitati (CategorieId, ActivitateId) VALUES (2, 1)
INSERT INTO CategoriiActivitati (CategorieId, ActivitateId) VALUES (1, 3)

INSERT INTO ActivitateClient (ClientId, ActivitateId, DataActivitatii, OraActivitatii) VALUES (3, 1, '01-01-2020', '20:30')
INSERT INTO ActivitateClient (ClientId, ActivitateId, DataActivitatii, OraActivitatii) VALUES (5, 2, '01-01-2020', '17:30')
INSERT INTO ActivitateClient (ClientId, ActivitateId, DataActivitatii, OraActivitatii) VALUES (6, 3, '01-01-2020', '20:30')
INSERT INTO ActivitateClient (ClientId, ActivitateId, DataActivitatii, OraActivitatii) VALUES (6, 1, '01-01-2020', '20:30')
/*2*/
/*Interogare care afiseaza pretul mediu pe noapte a unei cabane cu minim 3 locuri*/

SELECT AVG(c.PretNoapte)
FROM Cabana c 
WHERE c.NrLocuri > 2

/*3*/
ALTER VIEW FiveStarResort AS
SELECT TOP 3 WITH TIES COUNT(c2.ClientId) as NumberofClients, r.Nume as ResortName
FROM Resort r, Cabana c
INNER JOIN Cazare c2 ON c2.CabanaId = c.CabanaId 
WHERE r.ResortId = c.ResortId AND r.NumarStele = 5
GROUP BY r.Nume 
ORDER BY COUNT(c2.ClientId) DESC

SELECT * FROM FiveStarResort 

/*4*/
SELECT c.Nume, c.DataNasterii, c.TaraOrigine 
FROM Client c 
INNER JOIN ActivitateClient ac ON ac.ClientId = c.ClientId 
INNER JOIN Activitate a ON ac.ActivitateId = a.ActivitateId 
WHERE a.ActivitateId = ANY (SELECT a2.ActivitateId FROM Activitate a2
						INNER JOIN CategoriiActivitati ca ON ca.ActivitateId = a2.ActivitateId
						INNER JOIN Categorie c2 ON ca.CategorieId = c2.CategorieId
						WHERE c2.Nume = 'sport')
EXCEPT
SELECT c3.Nume, c3.DataNasterii, c3.TaraOrigine 
FROM Client c3
INNER JOIN ActivitateClient ac2 ON ac2.ClientId = c3.ClientId 
INNER JOIN Activitate a3 ON ac2.ActivitateId = a3.ActivitateId
WHERE a3.ActivitateId = ANY (SELECT a4.ActivitateId FROM Activitate a4
						INNER JOIN CategoriiActivitati ca2 ON ca2.ActivitateId = a4.ActivitateId
						INNER JOIN Categorie c4 ON ca2.CategorieId = c4.CategorieId
						WHERE c4.Nume = 'relaxare')
/*						
Select cl.namen 
From client cl INNER JOIN ActivityClients ac ON cl.id = ac.clId 
INNER JOIN activity a ON ac.acId = a.id WHERE 
a.namen = ANY(SELECT namen 
			from activity 
			WHERE namen='fobal')
EXCEPT
Select cl.namen
From client cl 
INNER JOIN ActivityClients ac ON cl.id = ac.clId 
INNER JOIN activity a ON ac.acId = a.id 
WHERE a.namen = ANY(SELECT namen 
					from activity WHERE
					namen='calarism')
/*
