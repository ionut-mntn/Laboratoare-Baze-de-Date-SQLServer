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

	set @i = 0
	while @i < 10000
	begin
			insert into Ta values (@i + 1)
			set @i = @i + 1
	end

	set @i = 0
	while @i < 3000
	begin
			insert into Tb values (@i + 1)
			set @i = @i + 1
	end

	set @i = 0
	while @i < 30000
	begin
			insert into Tc values ( @i % 10000 + 1, @i % 3000 + 1) -- aici era problema de la paranteze lipsa....... jeez ce prostie
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

-- PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1

exec sys.sp_helpindex @objname = N'Tc'

select * from sys.indexes
where object_id = OBJECT_ID('Tc')
--

exec sys.sp_helpindex @objname = N'Ta'

select * from sys.indexes
where object_id = OBJECT_ID('Ta')

-- select * from Ta
-- select * from Ta where idA > -1
select * from Tb

select a2 from Ta where idA = 3 -- stim ca idA este unique deci stim ca: where-ul este destul de restrictiv => apelam la un seek, adica ma uit doar dupa ce ma intereseaza pentru ca stiu sigur ca o sa il gasesc

select a2 from Ta -- se duce pe non-clustered pt ca dimensiunea acestuia e mai mica.. nu are si idA-ul

-- select a2 from Ta where idA = 3
select a2 from Ta where a2 > -1 -- non-clustered deoarece select-ul mi-l cere pe a2, iar conditia din 'where' mi-l cere tot pe a2, deci doar de a2 am nevoie, iar acesta se afla in indexul non-clustered.. (se afla si in clustered, dar asta non-clustered e mai mic ca dimensiune, deci: non-cluster 1 - 0 cluster so far. iar seek-ul apare pentru ca am un while pt care conditia este restrictiva. daca aveam o conditie de genul id2 > 0 ( care e adevarata pt toate intrarile din campul id2 in cazul meu, atunci aceea nu mai e "la fel" de restrictia asa ca din acest considerent am putea sa nu mai apelam la non-clustered; dar ramane considerentul anterior mentionat, deci tot la non-clustered se va apela)


