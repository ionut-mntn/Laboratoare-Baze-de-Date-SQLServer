create database S1
use S1
create table Sanger(
nume varchar(20) primary key,
popularitat int);

create table Lied(
lied_id int primary key, 
titel varchar(max),
dauer int);

create table Sanger_Lied(
nume varchar(20) foreign key references Sanger(nume),
lied_id int foreign key references Lied(lied_id),
primary key(nume, lied_id)
);

create table Plattenlabel(
id_plattenlabel int primary key, 
rating int);

create table Album(
album_id int primary key,
titel varchar(max),
veroffdatum date,
pltlabel int foreign key references Plattenlabel(id_plattenlabel)
);

create table Musikvideo(
id_musikvideo int primary key,
veroffdatum date
);

create table Konzert(
id_konzert int primary key,
ort varchar(max),
datum date,
zeit time(0),
);

create table Konzert_Sanger(
id_konzert int foreign key references Konzert(id_konzert),
nume varchar(20) foreign key references Sanger(nume),
primary key(id_konzert, nume)
);

Insert into Lied(lied_id, titel, dauer) values (1,'Take me away', 3 )
Insert into Lied(lied_id, titel, dauer) values (2,'Outside', 3 )
Insert into Lied(lied_id, titel, dauer) values (3,'Breath', 3 )
Insert into Lied values (4,'Breath', 3,100, 50 )
Insert into Lied values (5,'Hello', 3,100, 50 )
Insert into Lied values (6,'Hello', 32,100, 60 )

insert into Sanger values ('Smiley', 23000)
insert into Sanger values ('Rammstein', 530000)
insert into Sanger values ('Jazzrausch', 530000)

insert into Sanger_Lied values ('Smiley', 1)
insert into Sanger_Lied values ('Rammstein', 2)
insert into Sanger_Lied values ('Rammstein', 3)

insert into Plattenlabel values (11, 5000)

insert into Album values (50, 'Feuer', '12-23-2020', 11)
insert into Album values (60, 'Fun ', '12-23-2020', 11)

insert into Musikvideo values (100,1,'11.06.2020')
Select* from Musikvideo

insert into Konzert values (5,'Bucuresti','11-06-2020', '11:30')
insert into Konzert values (6,'Bucuresti','12-06-2020', '11:30')
insert into Konzert values (7,'Brasov','12-06-2020', '11:30')

insert into Konzert_Sanger values (5,'Rammstein' )
insert into Konzert_Sanger values (6, 'Rammstein' )
insert into Konzert_Sanger values (6,'Jazzrausch')
insert into Konzert_Sanger values (7,'Jazzrausch')

alter table Lied add  musikvideo int foreign key references Musikvideo(id_musikvideo)
alter table Lied add  album int foreign key references Album(album_id)

