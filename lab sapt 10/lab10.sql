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
	-- set nocount off -- care e faza cu asta??
	declare @i as int
	-- grija mare cu +1 / -1 astea !!
	set @i = 0
	while @i < 10000
	begin
			insert into Ta values (@i + 1) -- aici era problema de la paranteze lipsa....... jeez ce prostie
--			insert into Ta values (0 - @i - 1) -- aici era problema de la paranteze lipsa....... jeez ce prostie
			set @i = @i + 1
	end

	set @i = 0
	while @i < 3000
	begin
			insert into Tb values (@i + 1) -- aici era problema de la paranteze lipsa....... jeez ce prostie
--			insert into Tb values (0 - @i - 1) -- aici era problema de la paranteze lipsa....... jeez ce prostie
			set @i = @i + 1
	end

	set @i = 0
	while @i < 30000
	begin
			insert into Tc values ( @i % 10000 + 1, @i % 3000 + 1) -- aici era problema de la paranteze lipsa....... jeez ce prostie
--			insert into Tc values ( (0 - @i - 1) % 10000 + 1, (0 - @i - 1) % 3000) -- aici era problema de la paranteze lipsa....... jeez ce prostie
			set @i = @i + 1
	end
end
go

print -1 % 5

exec insereaza

--select * from Ta, Tb, Tc
select * from Ta
--order by idA
select * from Tb
select * from Tc

-- PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1


