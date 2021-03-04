create database Praktik3
use Praktik3

drop table Kinder
create table Kinder(
id int primary key,
[name] varchar(50),
vorname varchar(50),
geburtsdatum date,
telefonNummer bigint,
gruppeId int foreign key references Gruppe
)

drop table Gruppe
create table Gruppe(
id int primary key,
[name] varchar(50),
kapazitat int,
lehrer_id int foreign key references Lehrer
)

drop table Lehrer
create table Lehrer(
id int primary key,
[name] varchar(50),
vorname varchar(50),
geburtsdatum date,
)

drop table Ausbildung
create table Ausbildung(
id int primary key,
beschreibung varchar(50)
)

-- un profesor poate avea mai multe calficari, o calificare poate sa o aiba mai multi profesori

drop table LehrerAusbildung
create table LehrerAusbildung(
lehrer_id int foreign key references Lehrer,
ausbildung_id int foreign key references Ausbildung,
primary key(lehrer_id, ausbildung_id),
finishedDate date
)

create trigger insert_trigger
on Kinder
on insert
as
begin

	set nocount on;

	-- selectez intai nr maxim de copii admisi la grupa respectiva
	-- apoi compar cu nr de copii deja inscrisi la grupa respectiva

	declare @nrCopiiMax
	set @nrCopiiMax = (select i.gruppeId from inserted i -- doar pentru o inserare	
	join Gruppe g on g.id = i.gruppeId)
	
	if(select count(*) from inserted i
	join Gruppe g on g.id = i.id
	group by g.id -- stiu ca nu e bine sa fac pe id, sorry :(
	>= @nrCopiiMax)	-- daca capacitatea grupei pt care inserez copilul este mai mica 
	begin
		raiserror('Eroare!. Va rugam re-verificati nr maxim de copii admisi in grupa respectiva!',16,1)
	end
	else
	begin
		insert into Kinder
		select * from inserted i
		join Gruppe g on i.gruppeId = g.gruppeId
		where(g.kapazitat <= @nrCopiiMax)

	end

end





/*
Für die folgende Aufgaben erstelle eine neue Datebank mit den folgenden Tabellen. Ihr müsst nichts in dem Textbox schreiben.

Die Tabelle Konzertprogramm modelliert bei welcher Uhrzeit jede Band bei dem Konzert singt. 
Die Tabelle BandLied modelliert von welcher Band ein Lied gesungen wird. Ein Lied kann von mehreren Bands im Zusammenarbeit gesungen werden.
Die Tabelle LiedAlbum modelliert auf welchem Album sich ein Lied befindet. Ein Lied kann sich auf mehreren Alben befinden.
*/

create database Praktik2
use Praktik2

create table Genre (

Id int primary key,

GenreName varchar(20))



create table Band(

Id int primary key,

BandName varchar(50),

Grundungsjahr date,

GenreId int,

foreign key (GenreId) references Genre(Id))



create table Lied(

Id int primary key,

Titel varchar(10),

Dauer time)



create table BandLied(

LiedId int,

BandId int,

primary key (LiedId,BandId),

foreign key (LiedId) references Lied(Id),

foreign key (BandId) references Band(Id)

)



create table Plattenlabel(

Id int primary key,

PlattenlabelName varchar(30),

Rating float)



create table Album(

Id int primary key,

Titel varchar(100),

Preis float,

Veroffentlichsdatum date,

PlattenlabelId int,

foreign key (PlattenlabelId) references Plattenlabel(Id))



create table LiedAlbum(

IdLied int, 

IdAlbum int,

Position int

primary key(IdLied,IdAlbum),

foreign key (IdLied) references Lied(Id),

foreign key (IdAlbum) references Album(Id),)



create table Musikvideos(

Id int primary key,

Thema varchar(30),

LiedId int,

Veroffentlichsdatum date

foreign key (LiedId) references Lied(Id)

)



create table Konzert(

Id int primary key,

Veranstaltungsort varchar(30),

Datum date

)



create table Konzertprogramm(

KonzertId int,

BandId int,

Uhrzeit time,

primary key (KonzertId,BandId),

foreign key (KonzertId) references Konzert(Id),

foreign key (BandId) references Band(Id),

)

