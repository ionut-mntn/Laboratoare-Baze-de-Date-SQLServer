CREATE DATABASE Music;
USE Music;

CREATE TABLE Singer (
    SingerId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Name nvarchar(MAX),
    Popularity int
);

CREATE TABLE Song (
    SongId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Title nvarchar(MAX),
    Duration int
);

CREATE TABLE Featuring (
	FeaturingId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	
	SongId int,
	SingerId int,
	FOREIGN KEY(SongId) REFERENCES Song(SongId),
	FOREIGN KEY(SingerId) REFERENCES Singer(SingerId)
);

CREATE TABLE RecordLabel (
	RecordLabelId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	Rating int
);

CREATE TABLE Album (
    AlbumId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    Title nvarchar(MAX),
    LaunchDate date,
    RecordLabelId int,
    
    FOREIGN KEY (RecordLabelId) REFERENCES RecordLabel(RecordLabelId)
);

CREATE TABLE Videoclip (
    VideoclipId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    LaunchDate date,
    SongId int,
    
    FOREIGN KEY (SongId) REFERENCES Song(SongId)
);

CREATE TABLE Concert (
	ConcertId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	Location nvarchar(MAX),
	DateOf date,
	Hours time
);


CREATE TABLE Performers (
	PerformersId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	ConcertId int,
	SingerId int,
	
	FOREIGN KEY(ConcertId) REFERENCES Concert(ConcertId),
	FOREIGN KEY(SingerId) REFERENCES Singer(SingerId)
);

CREATE TABLE SongInAlbum (
	SongInAlbum int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	SongId int,
	AlbumId int,
	
	FOREIGN KEY(SongId) REFERENCES Song(SongId),
	FOREIGN KEY(AlbumId) REFERENCES Album(AlbumId)
);

INSERT INTO Singer(Name, Popularity) VALUES 
('Ariana Grande', 90),
('Jhene Aiko', 40),
('Kanye West', 100),
('Doja Cat', 60);

INSERT INTO Song(Title, Duration) VALUES 
('positions', 4),
('BS', 5),
('Runaway', 8),
('Juicy', 3);

INSERT INTO Featuring(SongId, SingerId) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(4, 1),
(2, 4);

ALTER TABLE RecordLabel 
ADD Name nvarchar(MAX);

INSERT INTO RecordLabel (Name, Rating) VALUES 
('label1', 5),
('label2', 7),
('label3', 8);

INSERT INTO Album (Title, LaunchDate, RecordLabelId) VALUES 
('Positions', '01-01-2020', 1),
('Chilombo', '02-01-2020', 2),
('Hot Pink', '03-01-2020', 3);

INSERT INTO Videoclip (LaunchDate, SongId) VALUES
('01-01-2020', 1),
('02-01-2020', 4);

INSERT INTO Concert (Location, DateOf, Hours) VALUES
('Cluj Arena', '02-03-20', '20:00'),
('Sala Polivalenta', '05-12-2020', '19:00');
INSERT INTO Concert (Location, DateOf, Hours) VALUES ('Horia Demian', '06-04-2020', '17:00')

INSERT INTO Performers (SingerId, ConcertId) VALUES 
(1, 1),
(2, 2);
INSERT INTO Performers (SingerId, ConcertId) VALUES (3, 1)
INSERT INTO Performers (SingerId, ConcertId) VALUES (3, 2)
INSERT INTO Performers (SingerId, ConcertId) VALUES (4, 3)


INSERT INTO SongInAlbum(SongId, AlbumId) VALUES 
(1, 1),
(2, 2),
(4, 3),
(3, 1);

/*2*/
ALTER VIEW Albums AS
SELECT a.Title , SUM(s.Duration) as duration
FROM Album a
INNER JOIN SongInAlbum sia ON sia.AlbumId = a.AlbumId 
INNER JOIN Song s ON s.SongId = sia.SongId
GROUP BY a.Title 

SELECT * FROM Albums

/*3*/
SELECT c.Location, c.DateOf, c.Hours 
FROM Concert c 
INNER JOIN Performers p ON c.ConcertId = p.ConcertId 
INNER JOIN Singer s ON p.SingerId = s.SingerId 
WHERE s.Name = 'Kanye West'
EXCEPT
SELECT c2.Location, c2.DateOf, c2.Hours 
FROM Concert c2 
INNER JOIN Performers p ON c2.ConcertId = p.ConcertId 
INNER JOIN Singer s ON p.SingerId = s.SingerId 
WHERE s.Name = 'Ariana Grande'

/*4*/
SELECT TOP 1 COUNT(p.ConcertId), c.Location 
FROM Performers p
INNER JOIN Concert c ON p.ConcertId = c.ConcertId 
GROUP BY c.Location 
ORDER BY COUNT(p.ConcertId) ASC

