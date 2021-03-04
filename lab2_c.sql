USE [Hotel Management]
/*	1.a
CREATE TABLE [Booking_Room](
[booking_id] VARCHAR(30),
[room_id] VARCHAR(30),
PRIMARY KEY (booking_id, room_id)
)


CREATE TABLE [Customer](
[ID] int PRIMARY KEY,
[first_name] NVARCHAR(40),
[last_name] NVARCHAR(40),
[email] NVARCHAR(MAX),
[birt_date] DATE,
[address_id] INT FOREIGN KEY REFERENCES [Address](address_id)
)
*/
-- 1.b
INSERT INTO [Address]
VALUES ('Sibiu', 'Maramuresului', 'Romania', 'Sibiu' , 10)
INSERT INTO [Address]
VALUES ('Sibiu', 'Argesului', 'Romania', 'Sibiu' , 15)
INSERT INTO [Address]
VALUES ('Sibiu', 'Banatului', 'Romania', 'Sibiu' , 20)
INSERT INTO [Address]
VALUES ('Cluj', 'Gheorghe Dima', 'Romania', 'Sibiu' , 25)
INSERT INTO [Address]
VALUES ('Cluj', 'Zorilor', 'Romania', 'Sibiu' , 30)
INSERT INTO [Address]
VALUES ('Bucuresti', 'Dristor', 'Romania', 'Bucuresti' , 55)
INSERT INTO [Address]
VALUES ('Bucuresti', 'Malului', 'Romania', 'Vitan' , 57)

INSERT INTO Customer
VALUES ('Calin','Nemes','calin_calinnemes@yahoo.com','06-11-2000',1505,2)
INSERT INTO Customer
VALUES ('Alin','Baiatfyn','alin_alinutz@yahoo.com','05-15-2005',1506,3)
INSERT INTO Customer
VALUES ('Mihai','Oancea','nammail@gmail.tk','06-29-2000',1505,4)
INSERT INTO Customer
VALUES ('Markus','Vrancea','mark_vrankea@yahoo.com','03-11-2000',1505,5)
INSERT INTO Customer
VALUES ('Bogdan','Mozacu','bobo_bob_bobo@yahoo.com','05-05-2000',1505,6)

INSERT INTO Hotel
VALUES (1505, 'Continental', 'Continental', 4, 9, 7)
INSERT INTO Hotel
VALUES (1506, 'Plapumioara', '3Garoafe', 1, 3, 8)


-- 1.c
/* Beispiel: insert into Customer values('Test','test','mailtest@yahoo.com',01-01-2001,1500, 1) address_id 1 gibt es nicht
*/


-- 1.d
UPDATE [Hotel]
SET star_rating=star_rating+1
WHERE chain_name = 'Continental' AND floor_count>7

DELETE FROM Customer
WHERE birth_date BETWEEN '01-01-1999' AND '01-01-2000'

DELETE FROM Customer
WHERE email IS NULL;

UPDATE [Address]
SET country='Romania' 
WHERE county LIKE 'Bu%esti'

UPDATE [Hotel]
SET star_rating= star_rating-1
WHERE floor_count IN (4,5,6)

-- 2
USE [Hotel Management]

SELECT C.last_name,C.first_name FROM Customer C, Hotel H		-- toti majorii de la Continental
WHERE birth_date < '10-19-2002'
INTERSECT
SELECT C.last_name,C.first_name FROM Customer C, Hotel H
WHERE c.hotel_id=h.hotel_id
AND h.hotel_name= 'Continental'

SELECT COUNT(hotel_id) as "Numar", star_rating	-- afiseaza numarul de hoteluri care au peste 3 stele, grupate descrescator in functie de nr de stele
FROM Hotel
WHERE star_rating>3
GROUP BY star_rating
ORDER BY star_rating DESC

SELECT TOP 3 *		-- afiseaza cele mai bune 3 hoteluri in functie de stele care au peste 6 etaje
FROM Hotel
WHERE floor_count IN (SELECT floor_count FROM HOTEL WHERE floor_count>6)	---------alt tabel
ORDER BY star_rating DESC

SELECT SUM(total_price) as "Cheltuieli", Hotel.hotel_name	-- cheltuielile totale ale hotelului Continental
FROM Expenses
INNER JOIN Hotel ON Expenses.hotel_id = Hotel.hotel_id
WHERE Hotel.hotel_id = 1505	--name
GROUP BY Hotel.hotel_id, Hotel.hotel_name	

SELECT AVG(price) as "Pret mediu", Hotel.hotel_name, Address.city		-- pretul mediu al unei camere din Continental
FROM Room
INNER JOIN Hotel ON Room.hotel_id = Hotel.hotel_id
INNER JOIN Address ON Address.adress_id = Hotel.adress_id
WHERE Hotel.hotel_id = 1505	-- name
GROUP BY Hotel.hotel_id,Hotel.hotel_name, Address.city

SELECT *		-- toate hotelurile de minim 5 stele in afara de Continental
FROM Hotel
WHERE star_rating > 4
EXCEPT
SELECT *
FROM Hotel
WHERE hotel_name = 'Continental' --name

SELECT first_name,last_name, Hotel.hotel_name		-- Toti clientii care au stat ori la Hilton, ori la Plapumioara
FROM Customer
INNER JOIN Hotel ON Hotel.hotel_id=Customer.hotel_id
WHERE Hotel.hotel_id = 1506
UNION
SELECT first_name, last_name, Hotel.hotel_name
FROM Customer
INNER JOIN Hotel ON Hotel.hotel_id=Customer.hotel_id
WHERE Hotel.hotel_id = 1507	-- name

SELECT Room.price,Room.status,Room.type, Hotel.hotel_name	--optiuni de camere disponibile sau mai ieftine de 350,sau eventuale optiuni din Hilton
FROM Room
FULL OUTER JOIN Hotel ON Hotel.hotel_id = Room.hotel_id
WHERE Room.status = 'libera' OR Room.price <=350 OR Hotel.hotel_id = 1507


SELECT DISTINCT Address.county	--judeturile din care vin clientii de la Continental, in afara de judetul in care e Continental 
FROM Address, Customer
WHERE Customer.address_id = Address.adress_id
AND Customer.hotel_id = 1505	-- name
AND Address.county NOT IN(SELECT Address.county
FROM Address, Hotel
WHERE Address.adress_id = Hotel.adress_id AND Hotel.hotel_id = 1505)


SELECT Hotel.hotel_name,Hotel.floor_count, Address.city	-- hotelurile care sunt mai inalte decat Venis si orasul in care sunt
FROM Hotel
INNER JOIN Address ON Address.adress_id = Hotel.adress_id
WHERE Hotel.floor_count > ALL(SELECT floor_count FROM Hotel WHERE hotel_id=1508)	--, dupa oras 


SELECT COUNT(hotel_id) as "Numar", floor_count as "Numar etaje", Address.city as "Oras"	-- cate hoteluri sunt care sa aiba peste 6 etaje
FROM Hotel
INNER JOIN Address ON Address.adress_id = Hotel.adress_id
WHERE floor_count > 6
GROUP BY Address.city, floor_count

-- having la grup, aggregate functions 2 ezempluri
-- + any 1