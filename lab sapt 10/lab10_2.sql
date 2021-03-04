drop table Tc

drop table Ta
create table Ta(
idA int identity(1,1) primary key,
a2 int unique
)

drop table Tb
create table Tb(
idB int identity(1,1) primary key,
b2 int 
)

create table Tc(
idC int identity(1,1) primary key,
idA int foreign key references Ta,
idB int foreign key references Tb
)

drop procedure insereaza
create procedure insereaza
as
begin

	declare @i as int

	set @i = 1
	while @i <= 10000
	begin
			insert into Ta values (@i)
			set @i = @i + 1
	end

	set @i = 1
	while @i <= 3000
	begin
			insert into Tb values (@i)
			set @i = @i + 1
	end

	set @i = 1
	while @i <= 30000
	begin
			insert into Tc values (@i % 10000, @i % 3000) -- aici era problema de la paranteze lipsa....... jeez ce prostie
			set @i = @i + 1
	end
end
go

exec insereaza

--select * from Ta, Tb, Tc
select * from Ta
--order by idA
select * from Tb
select * from Tc
where idB = 1

-- PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1


