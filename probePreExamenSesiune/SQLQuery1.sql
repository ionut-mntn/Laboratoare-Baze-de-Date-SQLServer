create table Raum(
Id int primary key,
[Name] varchar(50)
)
drop table Raum
/*
truncate table Raum
insert into Raum values
(1,'Kogalniceanu'),
(2,'Eminescu'),
(3,'Caragiale'),
(4,'Creanga'),
(5,'Arghezi'),
(6,'Carol I'),
(7,'Sadoveanu'),
(8,'Micle'),
(9,'Bastan'),
(10,'Alexandri')

create table proba(
id int primary key,
[name] varchar(50)
)
insert into proba values
(1,'a'),
(2,'b'),
(3,'c'),
(4,'d')

select [Name] from Raum
*/

create table Vorlesung(
Id int primary key,
Titel varchar(50),
ECTS int,
ProfessorId int foreign key references Professor
)
drop table Vorlesung
insert into Vorlesung values
(1,'Baze de date', 6, 1),
(2, 'Sisteme de operare', 6, 1),
(3, 'Fundamentele programarii', 6, 1),
(4, 'Algoritmica grafelor', 6, 1),
(5, 'Programare logica', 6, 1),
(6, 'Programare logica si functionala', 6, 1),
(7, 'Arhitectura sistemelor de calcul', 6, 1),
(8, 'Calcul diferential si integral', 6, 1),
(9, 'Fudnamentele Algebrice ale Informaticii', 6, 1),
(10, 'Informatica aplicata', 6, 1)


create table Professor(
Id int primary key,
[Name] varchar(50),
Vorname varchar(50),
Geburtsdatum date
)

insert into Professor values
(1, 'Vancea', 'Mihai', '1960-08-12')

create table Prufung(
VorlesungId int primary key,
Datum date,
RaumId int foreign key references Raum
)
drop table Prufung

insert into Prufung values
(1, '2021-01-27', 1),
(2, '2021-01-27', 2),
(3, '2021-01-27', 4),
(4, '2021-01-27', 5),
(5, '2021-01-27', 6),
(6, '2021-01-27', 7),
(7, '2021-01-27', 8)

update Prufung
set VorlesungId = null where VorlesungId = 2

select count(*) from Raum, Prufung -- deci un astel de select face un produs cartezian!!

select T1.nr1, T2.nr2 from
(select count(*) as nr1 from Raum r inner join Prufung P on R.Id = P.RaumId
inner join Vorlesung V on V.id = P.VorlesungId) T1,	-- pana aici am in paranteza un select deci un tabel - redenumit la final la T1; una din coloanele tabelului (si singura) se numeste nr1 deci cu '.' o accesez!
(select count(*) as nr2 from Vorlesung V2 where V2.Id not in 
														(select VorlesungId from Prufung)) T2


														-- deci practic trebuie sa scad din totalul



create table proba2(
id int primary key,
[name] varchar(50)
)
insert into proba2 (select * from proba)

