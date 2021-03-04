drop table Zug
create table Zug(
IdZug int primary key,
Name varchar(50),
IdZugtyp int foreign key references Zugtyp
)
insert into Zug values
(1, 'ABC123', 1)
(2, 'DEF456', 2)
(3, 'GHI789', 1)

drop table Zugtyp
create table Zugtyp(
IdZugtyp int primary key,
Beschreibung varchar(50)
)
insert into Zugtyp values
(1, 'de pasageri'),
(2, 'de marfa'),


drop table Bahnhof
create table Bahnhof(
IdBahnhof int primary key,
[Name] varchar(50)
)
insert into Bahnhof values
(1, 'Bucuresti Nord'),
(5, 'Suceava Nord'),
(7, 'Roman')

insert into Bahnhof values
(2, 'Bucuresti Est'),
(3, 'Bucuresti Vest'),
(4, 'Bucuresti Sud'),
(6, 'Suceava Est')

drop table [Route]
create table [Route](
IdRoute int primary key,
[Name] varchar(50),
IdZug int foreign key references Zug
)
insert into [Route] values
(1, 'Suceava Nord - Bucuresti Nord', 1),
(2, 'Suceava Nord - Bucuresti Est', 2)
(3, 'Suceava Nord - Bucuresti Vest full', 3)

drop table RoutenPlan
create table RoutenPlan(
IdRoute int foreign key  references [Route],
IdBahnhof int foreign key references Bahnhof,
Ankunftszeit time,
Abfahrtszeit time,
primary key (IdRoute, IdBahnhof)
)
insert into RoutenPlan values
(1, 5, '05:00', '05:10'), -- ruta Suceava Nord -> Bucuresti Nord; pleaca din Suceava la 05:10
(1, 7, '06:10', '06:20'), -- ruta Suceava Nord -> Bucuresti Nord; pleaca din Roman la 05:10
(1, 1, '12:00', '19:00')  -- ruta Suceava Nord -> Bucuresti Nord; pleaca din Bucuresti Nord (catre nicaeri, e ultima statie) la 19:00

insert into RoutenPlan values
(2, 5, '06:00', '06:10'), -- ruta Suceava Nord -> Bucuresti Vest; pleaca din Suceava la 05:10
(2, 7, '07:10', '07:20'), -- ruta Suceava Nord -> Bucuresti Vest; pleaca din Roman la 05:10
(2, 1, '13:00', '20:00'), -- ruta Suceava Nord -> Bucuresti Vest; pleaca din Bucuresti Nord la 19:00
(2, 2, '20:30', '21:00'), -- ruta Suceava Nord -> Bucuresti Vest; pleaca din Bucuresti Est la 19:30
(2, 3, '21:30', '21:30'), -- ruta Suceava Nord -> Bucuresti Vest; pleaca din Bucuresti Sud la 19:30
(2, 4, '22:30', '23:00')  -- ruta Suceava Nord -> Bucuresti Vest; pleaca din Bucuresti Vest (catre nicaeri, e ultima statie) la 22:00

select * from RoutenPlan

insert into RoutenPlan values
(3, 5, '05:15', '05:25'),
(3, 6, '07:10', '07:20'),
(3, 7, '13:00', '13:05'),
(3, 1, '14:00', '14:05'),
(3, 2, '14:10', '14:15'),
(3, 3, '14:20', '14:25'),
(3, 4, '14:30', '14:35')

select * from RoutenPlan
select * from [Route]


-- 1. un view cu numele tuturor rutelor care cuprind toate statiile de tren.


declare @trainStationsNumber int
set @trainStationsNumber = (select count(*) from Bahnhof)
--select * from Bahnhof
--select @trainStationsNumber

drop view [Alle Routen mit alle Bahnhofe]
create view [Alle Routen mit alle Bahnhofe] as
select rp.IdRoute, sum(*) as 'Nr gari tranzitate'
from RoutenPlan rp
group by rp.IdRoute
having count(rp.IdBahnhof) = ( select count(*) from Bahnhof)

select * from [Alle Routen mit alle Bahnhofe]



-- 2.


-- 3. trigger de verificare a datelor: sa nu am date care sa fie 


create trigger insert_trigger
on RoutenPlan
on insert
as
begin

--	declare @my_row_count int = @@ROWCOUNT
--	select @my_row_count
		
	insert into RoutenPlan--
	select * from inserted i
	where (i.Ankunftszeit not between '03:00' and '05:00')
	and (i.Abfahrtszeit not between '03:00' and '05:00')

	if(
	begin
		raiserror('Eroare!. Va rugam re-verificati integritatea datelor pe care doriti sa le introduceti!',16,1)
	end

	
end


/*
create table proba1(
a int primary key,
b int foreign key references 
)
*/






















/*
declare @alleBahnhofe table
(IdBahnhof int primary key)
insert into @alleBahnhofe -- values !! fara "values" aici!!
select IdBahnhof from Bahnhof
select * from @alleBahnhofe

create view [Alle Routen mit alle Bahnhofe] as
select r.IdRoute, count(*) as [count]-- asta dc nu merge ??
from [Route] r
inner join RoutenPlan rp on r.IdRoute = rp.IdRoute
group by r.IdRoute
having count(*) = (select count(*) from Bahnhof)

select * from [Alle Routen mit alle Bahnhofe]


select r.IdRoute, r.[Name] -- asta dc nu merge ??
from [Route] r
inner join RoutenPlan rp on r.IdRoute = rp.IdRoute
group by r.IdRoute, r.[Name]
having count(*) = (select count(*) from Bahnhof)



-- select r.[

CREATE VIEW RouteView AS
SELECT TOP 1 WITH TIES R.RouteID, R.Name
FROM [Route] R
INNER JOIN RoutenPlan RB on R.IdRoute=RB.IdRoute
GROUP BY R.IdRoute
HAVING COUNT(RB.IdBahnhof) <= 5
ORDER BY COUNT(RB.IdBahnhof) ASC

--

select * from [Route]
declare @var int
-- set @var = select top 1 IdRoute from [Route]
-- select into @var top 1 IdRoute from [Route]
-- insert into @var top 1 IdRoute from [Route]
-- insert into @var select top 1 IdRoute from [Route] -- asta merge !! dar doar daca var e table variable
-- set @var = (select top 1 IdRoute from [Route]) -- asta merge !!


select * from [Route]

select r1.* from [Route] r1
join [Route] r2 on r1.IdRoute = r2.IdRoute
