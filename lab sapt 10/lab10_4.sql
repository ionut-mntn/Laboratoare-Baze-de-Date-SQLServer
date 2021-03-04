drop table Tc

drop table Ta
create table Ta(
idA int identity(1,1) primary key,
a2 int unique,
a3 int
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
			insert into Ta values (@i + 1, @i + 1)
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

select * from Tb -- nu am index non-cluster ca sa existe vreo alta discutie, deci cluster. nu am conditie, astfel ca trebuie sa le caute pe toate, deci scan. 

select * from Tb where idB > 100 -- dc nu face scan aici? i-am dat o conditie care nu e restrictiva... pt ca POATE efectua cautarea necesara (solicitata de mine, user-ul) dupa ce are in index.. ca nu e 
-- nu am index non-cluster ca sa existe vreo alta discutie, deci cluster. am conditie care imi permite sa ma folosesc de index, deci seek (conditie utila, nu cum era in ex domn prof, ala cu Amount, OrerStatistics.. vezi caiet, fisier)

-- select * from Ta -- in non-clustered are si acolo id-ul si coloana a2, ca si in cel clustered. doar ca ma gandesc ca asta clustered e mai rapid.. deoarece ... ??? chiar, dc?
select a2 from Ta -- am nevoie doar de a2 si stiu ca am index doar pe a2, deci folosesc. scan pt ca imi trebuie toate... exista cazuri in care am conditie si sa apara scan, tho? (exceptand cazul dat de doamna profesoara cu ordinea acolo...)

select a2 from Ta where a2 > 100

--b)
-- select idA, a2, a3 from Ta -- scan clustered
-- select idA, a2, a3 from Ta where a2 > 100 -- clustered scan ( poate nu mai e asa restrictiva conditia )
-- select idA, a2, a3 from Ta where a2 > 10000 -- non-clustered seek + Key Lokup
-- select idA, a2, a3 from Ta where a2 = 100 -- non-clustered seek + Key Lookup (aici sigur e destul de restricitva conditia )
-- select idA, a2, a3 from Ta where a2 > -1
select a2, a3 from Ta where a2 = 100 -- conditie foarte restrictiva, deci clar o sa faca seek si apoi Key-LookUp ca sa il obtina pe a3
--... dar totusi.. are referinta la cheie.. ???Key Lookup-ul se foloseste de referinta aia la cheie???
-- iata, in exemplul de mai jos se face tot seek dar nu se mai face Key-Loookup pt ca am acea referinta la indexul clustered.
-- Deci, de aici trag concluzia ca: daca o sa imi trebuiasca - pe langa ce am in index - cheia primara din tabelul indexat(adica cel in care caut), atunci NU o sa se faca acel Key-Lookup!! ci o sa se ia cheia primara folosindu-se referinta catre indexul clustered!!
-- select a2, idA from Ta where a2 = 100

-- c)
--select * from Tb
-- select * from Tb where b2 % 10 = 0 -- a facut scan ici la un moment dat pentru ca la momentul acela nu avea alt index existent
-- select * from Tb where b2 % 100 = 0
-- select * from Tb where b2 % 1000 = 0
-- select * from Tb where b2 = 10
-- select * from Tb where b2 > 100
-- select * from Tb where b2 > 2000
select b2 from Tb where b2 > 2000 -- cost subtree fara indexul non-clustered: 0.0110.....
create unique nonclustered index b2Index on Tb(b2);
select idB, b2 from Tb where b2 > 2000 -- cost subtree cu indexul non-clustered: 0.0051.... deci injumatatit!
-- select idB, b2 from Tb where b2 = 10 -- ! din nou: pentru un asemenea query nu o sa faca Key Lookup pt ca are acea referinta catre indexul clustered pentru a obtine cheia primara; daca Tb avea si alte cooane si le includeam in selectul asta, atunci da.. ar fi facut Key Lookup pt a obtine atat idB cat si celelalte coloane in discutie
drop index Tb.b2Index

/*
	1) Observam ca s-a schimbat operatia... s-a trecut de la un scan pe indexul clustered ( deci interogarea tuturor inregistrarilor din tabela )
	la un seek pe indexul non-clustered, deci interogarea doar a inregistrarilor care ma intereseaza.
	
	2) Timpul de cautare pe arbore s-a injumatatit ( ma rog, cu o mica eroare de 0.1 acolo.. nu o mai luam in considerare ).
*/

-- d)

/*
select Tc.idC, Tc.idA, Ta.a2 from Tc-- bv boss ai scos o din greseala
inner join Ta on Tc.idA = Ta.idA
-- where Ta.idA % 100 = 0
where Ta.idA > 9000

--create unique nonclustered index Index_idA on Tc(idA) -- asa e sintaxa: cu paranteze, nu cu punct !
create nonclustered index Index_idA on Tc(idA) -- asa e sintaxa: cu paranteze, nu cu punct !
drop index Tc.Index_idA

select Tc.idC, Tc.idA, Ta.a2 from Tc-- bv boss ai scos o din greseala
inner join Ta on Tc.idA = Ta.idA
-- where Ta.idA % 100 = 0
where Ta.idA > 9000



select Tc.idC, Tc.idA, Tb.b2 from Tc-- bv boss ai scos o din greseala
inner join Tb on Tc.idB = Tb.idb
-- where Ta.idA % 100 = 0
where Tb.idB < 1000                         -- < 9000

--create unique nonclustered index Index_idB on Tc(idB) -- asa e sintaxa: cu paranteze, nu cu punct !
create nonclustered index Index_idB on Tc(idB) -- asa e sintaxa: cu paranteze, nu cu punct !
drop index Tc.Index_idB

select Tc.idC, Tc.idA, Tb.b2 from Tc-- bv boss ai scos o din greseala
inner join Tb on Tc.idB = Tb.idB
-- where Ta.idA % 100 = 0
where Tb.idB < 1000
*/







-- are sens sa fac join daca eu nu afisez nicio coloana din tabelul cu care fac join, ci imi trebuie doar in conditie pt ceva.. i guess so( dar imi trebuie in conditie, tho? asta da; vad ca da eroare altfel)
select Tc.idA from Tc-- bv boss ai scos o din greseala
inner join Ta on Tc.idA = Ta.idA
where Ta.idA > 9000

create nonclustered index Index_idA on Tc(idA) -- asa e sintaxa: cu paranteze, nu cu punct !
drop index Tc.Index_idA

select Tc.idA from Tc-- bv boss ai scos o din greseala
inner join Ta on Tc.idA = Ta.idA
where Ta.idA > 9000

-- nu se mai face hash match, ci un merge join ( cred ca astea sunt pentu legatura foreign key si primary key SAU sa imbine coloana gasita a id-urilor care corespund cu coloana cealalta --care cealalta...)
-- S-a optat de aceasta data pentru un seek pe nonclustered, in loc de vechiul scan pe clustered ( cu indexul, nu trebuie sa mai citeasca toata tabela !)
-- Timpul de cautare pe arbore s-a redus de la 0.09 la 0.01, deci de aproape 9 ori mai bine.



select Tc.idB from Tc-- bv boss ai scos o din greseala
inner join Tb on Tc.idB = Tb.idb
where Tb.idB < 1000                         -- < 9000

create nonclustered index Index_idB on Tc(idB) -- asa e sintaxa: cu paranteze, nu cu punct !
drop index Tc.Index_idB

select Tc.idB from Tc-- bv boss ai scos o din greseala
inner join Tb on Tc.idB = Tb.idb
where Tb.idB < 1000                         -- < 9000

-- nu se mai face hash match, ci un merge join ( cred ca astea sunt pentu legatura foreign key si primary key SAU sa imbine coloana gasita a id-urilor care corespund cu coloana cealalta --care cealalta...)
-- S-a optat de aceasta data pentru un seek pe nonclustered, in loc de vechiul scan pe clustered ( cu indexul, nu trebuie sa mai citeasca toata tabela !)
-- Timpul de cautare pe arbore s-a redus de la 0.09 la 0.02, deci de aproape 9 ori mai bine.


