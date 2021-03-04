drop table TrainType
create table TrainType(
[name] varchar(50) primary key,
[description] varchar(50)
)

drop table Train
create table Train(
id int primary key,
[name] varchar(50),
[type] varchar(50) foreign key references TrainType
)

drop table TrainStation
create table TrainStation(
id int primary key,
arriving_time time,
departure_time time
)

drop table [Route]
create table [Route](
id int primary key,
[name] varchar(50),
[train] int foreign key references Train,
train_station int foreign key references TrainStation
)

insert into TrainType values
('de calatori', 'agrement'),
('de marfa', 'industrial')
delete from TrainType

insert into Train values
(1,'Mocanita Moldovita', 'de calatori'),
(2,'Mocanita Oltisorul', 'de calatori')
delete from Train

insert into TrainStation values
(1,'10:00:00', '10:05:00'),
(2,'10:10:00', '10:20:00')
delete from TrainStation

insert into [Route] values
(1, 'Bucovina', 1, 1),
(2, 'Valea Oltului', 1, 2)
delete from Route

/*
create procedure createTable(@tableName varchar(25), @columnName varchar(25), @columnType varchar(25))
as
	begin

	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'create table ' + @tableName + '(' + @columnName + ' ' + @columnType + ' primary key)'
	
	print (@sqlQuery)
	exec (@sqlQuery)

	end
go
exec createTable 'proba2', 'ceva', 'int'
*/
--/////////////////////////////////////////////////////////////////////////////////
if 1 != 0
end


begin

create procedure procedura(@route int, @trainStation int, @arrivalTime time, @departureTime time)
as
	begin


	declare @auxTrainStationID int
	set @auxTrainStationID = select * from [Route] where id = @tr


	if(@trainStation = 

	if exists(select * from [Route] where id = @route) -- 
	begin
		
	end


	end
go
exec createTable 'proba2', 'ceva', 'int'
--/////////////////////////////////////////////////////////////////////////////////


create function addColumnRollback(@tableName varchar(25), @ColumnName varchar(25))
returns varchar(MAX)
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop column ' + @ColumnName

--	print (@sqlQuery)
--	exec(@sqlQuery)

	return @sqlQuery

	end
go
--exec addColumnRollback 'Sample_persons', 'ceva'
print dbo.addColumnRollback ('Sample_persons', 'ceva')



create function moreThanOne(@specifiedTime time)
returns table
as
	return
	
	select id from TrainStation				-- afisez statiile de tren (id-urile acestora)
	where arriving_time = '10:00:00'	-- pentru care ora de sosire a trenului coincide cu cea pasata ca parametru
	-- pana aici iau toate statiile de tren in care ajunge cel putin un tren la ora data
	group by id					-- grupate dupa orele la care ajung trenurile 
	having count(*) >= 1					-- dar le voi selecta doar pe cele care au mai mu


go
--exec addColumnRollback 'Sample_persons', 'ceva'
print dbo.moreThanOne('Sample_persons', 'ceva')

--/////////////////////////////////////////////////////////////////////////////

create view [Sportivi si antrenamente] as
select s.CNP, s.nume, s.prenume, sub.specializare, a.ora_start, a.ora_final, l.denumire
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
join Subclub sub on sub.id_subclub = s.id_subclub






create table [Route](
id int primary key,
[name] varchar(50),
[train] varchar(50) foreign key references Train,
train_station int foreign key references TrainStation
)

create view [Rute cu mai putin de 5 statii] as
/*
select * from [Route] r
where count(r.) = 1
order by count(*)


select top(5) from [Route]
*/

select r.id, r.[name] from [Route] r
join TrainStation ts on r.id = ts.id
group by r.id
having count(*) <= 5


