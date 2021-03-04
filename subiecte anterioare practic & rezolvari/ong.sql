USE Proiect

CREATE TABLE Voluntari (
idVoluntar int,
nume varchar(50),
dataNasterii date,
tip varchar(50),
PRIMARY KEY (idVoluntar)
)

CREATE TABLE Proiecte (
numeProiect varchar(50),
descirere varchar(MAX),
buget float,
idVoluntar int,
FOREIGN KEY (idVoluntar) REFERENCES Voluntari,
PRIMARY KEY (numeProiect)
)

CREATE TABLE VoluntariProiecte (
idVoluntar int,
numeProiect varchar(50),
FOREIGN KEY (idVoluntar) REFERENCES Voluntari,
FOREIGN KEY (numeProiect) REFERENCES Proiecte,
PRIMARY KEY (idVoluntar, numeProiect)
)

CREATE TABLE ONG (
numeONG varchar(50),
PRIMARY KEY (numeONG)
)

CREATE TABLE Donatii (
numeDonatie varchar(50),
suma float,
dataDonatie date,
numeONG varchar(50),
FOREIGN KEY (numeONG) REFERENCES ONG,
PRIMARY KEY (numeDonatie)
)

CREATE TABLE Campanii (
numeCampanie varchar(50),
locatie varchar(MAX),
dataCampanie date,
suma float,
numeONG varchar(50),
FOREIGN KEY (numeONG) REFERENCES ONG,
PRIMARY KEY (numeCampanie)
)

CREATE TABLE VoluntariCampanie (
idVoluntar int,
numeCampanie varchar(50),
FOREIGN KEY (idVoluntar) REFERENCES Voluntari,
FOREIGN KEY (numeCampanie) REFERENCES Campanii,
PRIMARY KEY (idVoluntar, numeCampanie)
)

SELECT distinct Voluntari.nume
FROM Voluntari 
INNER JOIN VoluntariProiecte
	ON Voluntari.idVoluntar = VoluntariProiecte.idVoluntar
INTERSECT
SELECT distinct Voluntari.nume
FROM Voluntari 
INNER JOIN VoluntariCampanie
	ON Voluntari.idVoluntar = VoluntariCampanie.idVoluntar


ALTER VIEW [volunteers] AS
	SELECT Voluntari.nume, Count(VoluntariProiecte.idVoluntar) AS Nr
	FROM VoluntariProiecte
	INNER JOIN Voluntari
		ON Voluntari.idVoluntar = VoluntariProiecte.idVoluntar
	GROUP BY Voluntari.nume
	
	

SELECT * FROM [volunteers] order by Nr

SELECT VoluntariProiecte.numeProiect
FROM VoluntariProiecte
GROUP BY VoluntariProiecte.numeProiect
HAVING COUNT(*) > (SELECT COUNT(VoluntariCampanie.idVoluntar) FROM VoluntariCampanie)