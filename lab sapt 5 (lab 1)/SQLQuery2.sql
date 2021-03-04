create database lab1

use lab1

/*
create table Instrument(
id_instrument int primary key -- nume, tip, pk/fk ..tralala
)
drop table Instrument

alter table Instrument		-- finally !!
--add column -- dc nu merge cu column?
add
nume varchar(20),
greutate float,
uz varchar(50);

alter table Instrument
drop column
forma,
uz;

alter table
id_instrument int identity(1, 1) primary key
*/

create table Instrument(
id_instrument int identity(1, 1) primary key,
denumire varchar(50),
greutate float,
uz varchar(50)
)
drop table Instrument

alter table Instrument
drop column uz


create table Subclub(
id_subclub int identity(1,1) primary key,
nume varchar(50)
)
drop table Subclub


alter table Subclub drop column
--alter table Subclub
-drop column id_adresa

drop table Adresa

create table Adresa(
tara varchar(50),
judet varchar(50),
oras varchar(50),
strada varchar(50),
numar varchar(50)
)
-- drop table Adresa -- scrisesem 'juet' in loc de 'judet'
alter table Adresa
add
--id_adresa int not null identity(1,1) primary key
id_adresa int identity(1,1) primary key

alter table Subclub
add
specializare varchar(50),
id_adresa int foreign key references Adresa

insert into Adresa(tara, oras, strada, numar) values -- fara paranteze aici
('Romania', 'Bucuresti', 'Stefan cel Mare', '1'),
('Romania', 'Bucuresti', 'Stefan cel Mare', '2'),
('Romania', 'Bucuresti', 'Stefan cel Mare', '3')

insert into Adresa values
('Romania', 'Suceava', 'Suceava', 'Stefan cel Mare', '18'),
('Romania', 'Brasov', 'Brasov', 'Petru Rares', '23')

insert into Adresa values
('Romania', NULL,	'Bucuresti',	'Stefan cel Mare',	23),
('Romania', NULL,	'Bucuresti',	'Stefan cel Mare',	49),
('Romania', NULL,	'Bucuresti',	'Stefan cel Mare',	52)

alter table subclub
add -- aici la add nu pun `column`, dar la drop trebuie sa pun column
id_adresa int foreign key references Adresa

create table Locatie(
id_locatie int identity(1, 1) primary key,
capacitate int,
interior bit,
id_adresa int foreign key references Adresa
)
drop table Locatie


insert into Locatie values
( 50000,	'False',	10),
(10000,	'True',	11),
(3000,	'True',	12)

insert into Locatie values
( 50, 'True', 11),
( 30, 'False', 10)
insert into Locatie values
(500, 'False',  10), -- teren de fotbal mic
(300, 'True', 12)

insert into Locatie values
( 40, 'True', 11, 'teren fotbal')

alter table Locatie
add
denumire varchar(50)

update Locatie
set id_adresa = 10
where denumire = 'teren fotbal'

update Locatie
set id_adresa = 11
where capacitate = 500


update Locatie
set denumire = 'stadion'
where capacitate = 50000

update Locatie
set denumire = 'sala polivalenta'
where capacitate = 10000

update Locatie
set denumire = 'bazin'
where capacitate = 3000 or capacitate = 300

update Locatie
set denumire = 'sala forta'
where capacitate = 50 or capacitate = 30

update Locatie
set capacitate = 5000
where id_locatie = 2

update Locatie
set denumire = 'sala polivalenta'
where capacitate = 500

update Locatie
set interior = 'False'
where id_locatie = 10

insert into Adresa values
('Romania', NULL, 'Bucuresti', 'Stefan cel Mare', 68) 

insert into Locatie values
(200, 'true', 13, 'patinoar') -- cred ca daca schimbam din designer ordinea atributelor nu mai mergea o insertie de genul
/*
update Locatie
delete 
where denumire = 'patinoar'
*/
-- independenta de tabel nu merge!
constraint CHK_nr_cifre_cnp check (1000000000000<= CNP and CNP <= 9999999999999)

/*
insert into Locatie_valabila 
values
10	1
10	2
11	2
11	7
11	8
11	1
12	1
12	2
12	7
12	8
13	9
13	8
14	3
14	7
14	10
15	3
15	7
15	10
16	11
*/


create table Membru_staff_tehnic(
CNP bigint primary key,
constraint Membru_staff_tehnic_CHK_nr_cifre_cnp check (1000000000000<= CNP and CNP <= 9999999999999),
nume varchar(50),
specialitate varchar(50),
ani_experienta int,
)
drop table Membru_staff_tehnic

alter table Membru_staff_tehnic
drop constraint CHK_nr_cifre_cnp

alter table Membru_staff_tehnic
add -- aici e fara column
prenume varchar(50)




create table Angajati(
CNP bigint foreign key references Membru_staff_tehnic,
id_subclub int foreign key references Subclub,
primary key (CNP, id_subclub)
)
drop table Angajati

alter table Angajati
add 
constraint Angajati_CHK_nr_cifre_CNP check (1000000000000<= CNP and CNP <= 9999999999999)

drop constraint



create table Locatie_valabila(
id_subclub int foreign key references Subclub,
id_locatie int foreign key references Locatie
primary key (id_subclub, id_locatie)
)
drop table Locatie_valabila
--/*
create table Sportiv(
CNP bigint,
--constraint Sportiv_CHK_nr_cifre_CNP check (1000000000000<= CNP and CNP <= 9999999999999),
inaltime float,
greutate float,
masa_musculara float,
densitate_osoasa float,
id_subclub int foreign key references Subclub
)
drop table Sportiv
--alter table Sportiv
--

-- asa nu merge!
alter table Sportiv
alter column CNP int NOT NULL
alter table Sportiv
alter column CNP bigint -- atentie ca aici daca fac asa imi scoate "NOT NULL" ul de mai sus


-- poate asa... da, asa merge
alter table Sportiv
alter column CNP bigint not null

alter table Sportiv
add primary key(CNP)

alter table Sportiv
add
constraint Sportiv_CHK_nr_cifre_CNP check (1000000000000<= CNP and CNP <= 9999999999999)

alter table Sportiv
add
nume varchar(50),
prenume varchar(50)

--set CNP primary key

-- De ce nu mergea cu chestiile de mai sus? Cred ca pentru ca aveam prea multe alter-uri; cred
-- tot ce vreau sa modific pun intr-un alter.
-- Vad ca acuma merge cu varianta asta de deasupra deci prolly ca un alter
-- adus asupra aceleiasi coloane 
--*/
create table Sportiv(
CNP bigint primary key,
constraint Sportiv_CHK_nr_cifre_CNP check (1000000000000<= CNP and CNP <= 9999999999999),
inaltime float,
greutate float,
masa_musculara float,
densitate_osoasa float,
id_subclub int foreign key references Subclub
)
drop table Sportiv

create table Antrenament(
id_antrenament int identity(1, 1) primary key,
CNP bigint foreign key references Sportiv,
id_locatie int foreign key references Locatie,
tip varchar(50),
zi date,
ora_start time(7),
ora_final time(7)
)
drop table Antrenament

/*
alter table
add
antrenor
*/

create table Uz_materiale_anexe(
id_antrenament int foreign key references Antrenament,
id_instrument int foreign key references Instrument,
primary key (id_antrenament, id_instrument)
)
drop table uz_materiale_anexe
--=====================================================================================================================================================================
--de aici introducere de date

delete from Subclub -- aici de exemplu de ce nu punem stelutza ca la select?

insert into Subclub values
('fotbal', 'FC Dinamo Bucuresti', 1),
('handbal', 'HC Dinamo Bucuresti', 2),
('baschet', 'BC Dinamo', 3),
('volei', 'CS Dinamo', 4),
('inot', 'Dinamo Dolphins', 5),
('polo', 'CP Dinamo', 5),
('hochei', 'CH Dinamo', 5)



/*
1	Romania	NULL	Bucuresti	Stefan cel Mare	1
2	Romania	NULL	Bucuresti	Stefan cel Mare	2
3	Romania	NULL	Bucuresti	Stefan cel Mare	3
4	Romania	NULL	Bucuresti	Stefan cel Mare	4
5	Romania	NULL	Bucuresti	Stefan cel Mare	5
6	Romania	Brasov	Brasov	Petru Voda	23
7	Romania	Suceava	Suceava	Mihail Kogalniceanu	12
*/

/*
1	fotbal	FC Dinamo Bucuresti	1
2	handbal	HC Dinamo Bucuresti	2
3	baschet	BC Dinamo	3
4	volei	CS Dinamo	4
5	inot	Dinamo Dolphins	5
8	polo	CP Dinamo	5
9	hochei	CH Dinamo	5
*/

/*
1850517433039	Meme	Stoica	fotbal	12
1890412292651	Mirel	Radoi	fotbal	3
1890412292654	Luculescu	Sebastian	handbal	5
1910601406687	Mircea	Lucescu	fotbal	35
1910910137793	Chira	Bogdan	handbal	7
1991114321995	Manolescu	Gabriel	handbal	10
1920610205693	Stoican	Viorel	baschet	4
1860407204408	Fica	Andrei	baschet	6
1920420426005	Lupsor	Catalin	baschet	10
1921114225122	Ganea	Ioan	volei	22
1871015263025	Iftimie	Paul	volei	15
1991026341065	Nicoara	Marius	volei	11
1860429302405	Miclaus	Raul	inot	30
1971229295290	Moscaliuc	Cezar	inot	14
1850617177260	Rusescu	Claudiu	inot	7
1941228389992	Muntean	Sebastian	polo	5
1900315040641	Acatrinei	Vasile	polo	6
1860919116155	Baisanu	George	polo	16
1960916327450	Constantinescu	Bogdan	hochei	10
1851104305387	Constantinescu	Ionut	hochei	12
*/

drop table Angajati
drop table Membru_staff_tehnic

insert into Membru_staff_tehnic values
(1850517433039,	'Meme',	'Stoica',	'fotbal',	12),
(1890412292651, 'Mirel',	'Radoi',	'fotbal',	3),
(1890412292654,	'Luculescu',	'Sebastian',	'handbal',	5),
(1910601406687,	'Mircea',	'Lucescu',	'fotbal',	35),
(1910910137793,	'Chira',	'Bogdan',	'handbal',	7),
(1991114321995,	'Manolescu',	'Gabriel',	'handbal',	10),
(1920610205693,	'Stoican',	'Viorel',	'baschet',	4),
(1860407204408,	'Fica',	'Andrei',	'baschet',	6),
(1920420426005,	'Lupsor',	'Catalin',	'baschet',	10),
(1921114225122,	'Ganea',	'Ioan',	'volei',	22),
(1871015263025,	'Iftimie',	'Paul',	'volei',	15),
(1991026341065,	'Nicoara',	'Marius',	'volei',	11),
(1860429302405,	'Miclaus',	'Raul',	'inot',	30),
(1971229295290,	'Moscaliuc',	'Cezar',	'inot',	14),
(1850617177260,	'Rusescu',	'Claudiu', 'inot',	7),
(1941228389992,	'Muntean',	'Sebastian',	'polo',	5),
(1900315040641,	'Acatrinei',	'Vasile',	'polo',	6),
(1860919116155,	'Baisanu',	'George',	'polo',	16),
(1960916327450,	'Constantinescu',	'Bogdan',	'hochei',	10),
(1851104305387,	'Constantinescu',	'Ionut',	'hochei',	12)

drop table Angajati

insert into Angajati values
(1850517433039,	10),
(1850617177260,	14),
(1851104305387,	16),
(1860407204408,	12),
(1860429302405,	14),
(1860919116155,	15),
(1871015263025,	13),
(1890412292651,	10),
(1890412292654,	11),
(1900315040641,	15),
(1910601406687,	10),
(1910910137793,	11),
(1920420426005,	12),
(1920610205693,	12),
(1921114225122,	13),
(1941228389992,	15),
(1960916327450,	16),
(1971229295290,	14),
(1991026341065,	13),
(1991114321995,	11)


insert into Sportiv values
(5001225357677, 'Muntean', 'Andrei', 1.75, 68, 55, 3, 10),
(5001225357678, 'Popescu', 'Bogdan', 1.73, 62, 50, 2.7, 10),
(5001225357679, 'Gavrilovici', 'Paul', 1.85, 74, 63, 2.8, 10),

(5001225357780, 'Negru', 'Andrei', 1.82, 78, 66, 3.2, 11),
(5001225357781, 'Floristean', 'Raul', 1.85, 83, 68, 3.1, 11),
(5001225357782, 'Cosovaci', 'Mircea', 1.88, 75, 67, 3, 11),

(5001225357783, 'Miroslovici', 'Dumitru', 2.00, 92, 70, 3, 12),
(5001225357784, 'Mitrea', 'Marcel', 1.92, 88, 72, 2.9, 12),
(5001225357785, 'Pintilei', 'Sergiu', 1.85, 75, 65, 3.1, 12),

(5001225357786, 'Oleniuc', 'Claudiu', 1.90, 80, 70, 2.8, 13),
(5001225357787, 'Morosan', 'Bogdan', 1.95, 80, 71, 2.9, 13),
(5001225357788, 'Pintea', 'Raul', 1.84, 70, 63, 2.7, 13),

(5001225357789, 'Atodiresei', 'Andrei', 1.85, 73, 67, 2.9, 14),
(5001225357890, 'Baican', 'Vlad', 1.78, 70, 63, 2.8, 14),
(5001225357891, 'Todiras', 'Andrei', 1.79, 71, 64, 2.8, 14),

(5001225357892, 'Solovastru', 'Silviu', 2.00, 94, 75, 3.2, 15),
(5001225357893, 'Fodor', 'Andrei', 1.90, 80, 68, 3.1, 15),
(5001225357894, 'Milosteanu', 'Alexandru', 1.88, 80, 65, 2.8, 15),

(5001225357895, 'Condrea', 'Eusebiu', 1.85, 75, 65, 2.7, 16),
(5001225357896, 'Condrea', 'Sebastian', 1.85, 75, 65, 2.8, 16)


insert into Instrument values
(1,	'haltera',	2.5),
(2,	'haltera',	3),
(3,	'haltera',	3.5),
(4,	'bara zimtata',	2),
(5,	'bara',	2),
(6,	'banda stretching',	0.2),
(7,	'band stretching',	0.4),
(8,	'banda alergat',	115),
(9,	'bicicleta',	90),
(10,	'suport',	65),
(11,	'obstacol',	1)


/*
insert into Antrenament values
5001225357677	Muntean	Andrei	1.75	68	55	3	10
5001225357678	Popescu	Bogdan	1.73	62	50	2.7	10
5001225357679	Gavrilovici	Paul	1.85	74	63	2.8	10
5001225357780	Negru	Andrei	1.82	78	66	3.2	11
5001225357781	Floristean	Raul	1.85	83	68	3.1	11
5001225357782	Cosovaci	Mircea	1.88	75	67	3	11
5001225357783	Miroslovici	Dumitru	2	92	70	3	12
5001225357784	Mitrea	Marcel	1.92	88	72	2.9	12
5001225357785	Pintilei	Sergiu	1.85	75	65	3.1	12
5001225357786	Oleniuc	Claudiu	1.9	80	70	2.8	13
5001225357787	Morosan	Bogdan	1.95	80	71	2.9	13
5001225357788	Pintea	Raul	1.84	70	63	2.7	13
5001225357789	Atodiresei	Andrei	1.85	73	67	2.9	14
5001225357890	Baican	Vlad	1.78	70	63	2.8	14
5001225357891	Todiras	Andrei	1.79	71	64	2.8	14
5001225357892	Solovastru	Silviu	2	94	75	3.2	15
5001225357893	Fodor	Andrei	1.9	80	68	3.1	15
5001225357894	Milosteanu	Alexandru	1.88	80	65	2.8	15
5001225357895	Condrea	Eusebiu	1.85	75	65	2.7	16
5001225357896	Condrea	Sebastian	1.85	75	65	2.8	16
*/

-- fotbal, handbal, baschet, volei, inot, polo, hochei
insert into Antrenament values
(5001225357677,  1.75	68	55	3	10
5001225357678	Popescu	Bogdan	1.73	62	50	2.7	10
5001225357679	Gavrilovici	Paul	1.85	74	63	2.8	10

5001225357780	Negru	Andrei	1.82	78	66	3.2	11
5001225357781	Floristean	Raul	1.85	83	68	3.1	11
5001225357782	Cosovaci	Mircea	1.88	75	67	3	11

5001225357783	Miroslovici	Dumitru	2	92	70	3	12
5001225357784	Mitrea	Marcel	1.92	88	72	2.9	12
5001225357785	Pintilei	Sergiu	1.85	75	65	3.1	12

5001225357786	Oleniuc	Claudiu	1.9	80	70	2.8	13
5001225357787	Morosan	Bogdan	1.95	80	71	2.9	13
5001225357788	Pintea	Raul	1.84	70	63	2.7	13

5001225357789	Atodiresei	Andrei	1.85	73	67	2.9	14
5001225357890	Baican	Vlad	1.78	70	63	2.8	14
5001225357891	Todiras	Andrei	1.79	71	64	2.8	14

5001225357892	Solovastru	Silviu	2	94	75	3.2	15
5001225357893	Fodor	Andrei	1.9	80	68	3.1	15
5001225357894	Milosteanu	Alexandru	1.88	80	65	2.8	15

5001225357895	Condrea	Eusebiu	1.85	75	65	2.7	16
5001225357896	Condrea	Sebastian	1.85	75	65	2.8	16

5001225357897	Mihaila	Claudiu	1.77	70	58	2.8	NULL !!!
5001225357898	Borcea	Mirel	1.73	65	53	3	NULL !!!
--=====================================================================================================================================================================
select * from Subclub