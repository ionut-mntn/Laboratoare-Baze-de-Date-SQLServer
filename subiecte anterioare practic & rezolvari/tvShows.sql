USE TV

CREATE TABLE Categorii (
categorie varchar(50),
PRIMARY KEY (categorie)
)

CREATE TABLE TVShows (
idShow int,
numeShow varchar(MAX),
rating float,
categorie varchar(50),
PRIMARY KEY (idShow),
FOREIGN KEY (categorie) REFERENCES Categorii
)

CREATE TABLE Actori (
idActor int,
numeActor varchar(MAX),
PRIMARY KEY (idActor)
)

CREATE TABLE Shows_Actors (
idShow int,
idActor int,
FOREIGN KEY (idShow) REFERENCES TVShows,
FOREIGN KEY (idActor) REFERENCES Actori,
PRIMARY KEY (idShow, idActor)
)

CREATE TABLE Abonamente (
numeAbo varchar(50),
pret float,
PRIMARY KEY (numeAbo)
)

CREATE TABLE Spectatori (
idSpectator int,
numeSpectator varchar(MAX),
numeAbo varchar(50),
FOREIGN KEY (numeAbo) REFERENCES Abonamente,
PRIMARY KEY (idSpectator)
)

CREATE TABLE Vizionari (
idSpectator int,
idShow int,
watchTime datetime,
FOREIGN KEY (idSpectator) REFERENCES Spectatori,
FOREIGN KEY (idShow) REFERENCES TVShows,
PRIMARY KEY (idSpectator, idShow, watchTime)
)


ALTER VIEW [next_financial] AS
	SELECT numeSpectator as Nume
	FROM Spectatori
	INNER JOIN Vizionari
	   ON Spectatori.idSpectator = Vizionari.idSpectator
	INNER JOIN TVShows
	   ON Vizionari.idShow = TVShows.idShow
	WHERE TVShows.numeShow LIKE 'Next Star'
	INTERSECT
	SELECT numeSpectator as Nume
	FROM Spectatori
	INNER JOIN Vizionari
	   ON Spectatori.idSpectator = Vizionari.idSpectator
	INNER JOIN TVShows
	   ON Vizionari.idShow = TVShows.idShow
	WHERE TVShows.numeShow LIKE 'Financial Education'
	--WHERE TVShows.numeShow LIKE 'Next Star' AND Vizionari.idShow IN (SELECT TVShows.idShow WHERE TVShows.numeShow LIKE 'Financial Education')  

SELECT * FROM [next_financial]	


SELECT TVShows.numeShow, COUNT(Vizionari.idShow) AS NrVizionari
FROM Vizionari
INNER JOIN TVShows
	ON TVShows.idShow = Vizionari.idShow
GROUP BY numeShow
HAVING COUNT(*) > ANY (SELECT Vizionari.idShow FROM Vizionari INNER JOIN TVShows
	ON TVShows.idShow = Vizionari.idShow WHERE numeShow LIKE 'Megastar')


SELECT Spectatori.numeAbo, SUM(Abonamente.pret) AS PretTotal
FROM Abonamente
INNER JOIN Spectatori
	ON Spectatori.numeAbo = Abonamente.numeAbo
GROUP BY Spectatori.numeAbo
HAVING COUNT(*) >= 3
