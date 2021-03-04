create database [Labor]
use [Labor]
create table [Ta] (
[idA] int primary key,
[a2] int unique
)

create table [Tb] (
[idB] int primary key,
[b2] int,
[c2] int
)

create table [Tc](
[idC] int primary key,
[idA] int foreign key references Ta(idA),
[idB] int foreign key references Tb(idB)
)
drop Table Tc,Tb,Ta
go
create or alter procedure Inserare
as
	declare @pk int
	declare @ct int
	declare @ct2 int
	
	set @pk=1
	set @ct=1

--inserare in Ta
	while @pk<=10000
	begin
		insert into Ta values (@pk,@ct)
		set @pk=@pk+1
		set @ct=@ct+1
	end

	set @pk=1
	set @ct=1
	set @ct2=1

--inserare in Tb
	while @pk<=3000
	begin
		insert into Tb values (@pk,@ct,@ct2)
		set @pk=@pk+1
		set @ct=@ct+1
		set @ct2=@ct2+1
	end
	
	set @pk=1
	set @ct=1
	set @ct2=1
--inserare in Tc
	while @pk<=30000
	begin
		
		if @ct>10000
		begin
			set @ct=1
		end
		
		if @ct2>3000
		begin
			set @ct2=1
		end
	
		insert into Tc values (@pk,@ct,@ct2)
		set @pk=@pk+1
		set @ct=@ct+1
		set @ct2=@ct2+1
	end
go;

exec Inserare
select * from Ta
select * from Tb
select * from Tc
--1
select Tc.idC,Tc.idA,Tc.idB from Tc where idC=30000 and idA=10000 and idB=3000

--2 a.
exec sys.sp_helpindex @objname = N'Tc'

select * from sys.indexes
where object_id = OBJECT_ID('Tc')


exec sys.sp_helpindex @objname = N'Tb'

select * from sys.indexes
where object_id = OBJECT_ID('Tb')


exec sys.sp_helpindex @objname = N'Ta'

select * from sys.indexes
where object_id = OBJECT_ID('Ta')

select idA from Ta -- scan nonClustered
select idA from Ta where a2>300 --seek nonClustered

select idC from Tc -- scan clustered
select idC from Tc where idC>400 --seek clustered

--2 c.
select b2 from Tb where b2 > 2000 -- cost subtree fara indexul non-clustered: 0.0110

create unique nonclustered index b2Index on Tb(b2);
drop index Tb.b2Index

select idB, b2 from Tb where b2 > 2000 -- cost subtree cu indexul non-clustered: 0.0051 --> injumatatit

--scan pe indexul clustered --> seek pe indexul non-clustered
--timpul de cautare pe arbore s-a injumatatit 

select * from Tb
select b2, c2 from Tb where b2 = 700