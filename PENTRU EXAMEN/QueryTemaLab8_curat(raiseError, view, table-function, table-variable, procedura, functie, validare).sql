-- cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1 cerinta 1

create function validateName(@Name varchar(50))
returns varchar(Max)
as
begin

	if @Name not like '%[^a-zA-Z]%' -- dubla negatie ca sa obtin exact literele!
	begin
		return @Name
	end

	-- ; throw 50000, 'Numele nu este valid!', 1; -- nu stiu de ce, dar asa nu merge...
	-- raiserror ('Numele nu este valid!', 10, 1)

	return '-1'

	end
go
print dbo.validateName('Jackson2')

create function validateTime(@Time time)
returns time
as
begin
	
	if @Time not between '02:01:00' and '09:59:59' -- a doua valoare trebuie neaparat sa fie 0 daca eu returnez tipul bit!
	begin
		return @Time
	end
	
	-- ; throw 50000, 'TImpul introdus nu este valid!', 1
	-- raiserror ('Timpul nu este valid!', 10, 1)

	return '03:59:59' -- returnez o ora la care stiu ca nu voi incepe niciodata un film, adica una care nu e in intervalul de functionare, ba mai mult daca
	-- ar fi fost un cinema nonstop, niciun film nu incepe la 59:59, let's be serious

end
go
print dbo.validateTime('14:00:00')
print dbo.validateTime('02:00:00')

/*
select * from sys.messages
--where 50000 < message_id and message_id < 60000
where message_id like'5%'

select iif(@Time not between '02:00' and '10:00', 1, 0))
*/


create procedure validatedInsertion(@Titel varchar(100), @Regisseur varchar(30), @Kino varchar(30), @Telefonnummer bigint, @Zeit time)
as
begin
	/*
	begin try
		insert into 'Filmliste' values
		(@Titel, 
	end try
	begin catch

	end catch
	*/

	set @Regisseur = dbo.validateName(@Regisseur) -- sa nu uitam de set!
	if @Regisseur = '-1' -- e nasol sa fac asa 2 verificari dar nu stiam cum sa arunc exceptie in functie si sa tratez aici intr-un catch...
	begin
		raiserror('Numele regizorului nu este valid! Va rugam introduceti un nume format doar din caractere alfabetice!', 10, 1)
		-- raiserror asta cred ca ar cam fi trebuit sa apara in functie! doar ca... cum as fi aruncat mai departe pentru tratare in procedura??
		-- workaround ul ala cu 'cast la int' de pe net nu prea-mi place.. nu pare profi (ceva de genul: ' return cast('Error happened here.' as int)' )
		return
	end

	set @Zeit = dbo.validateTime(@Zeit)
	if @Zeit = '03:59:59' -- varianta asta cade daca am un cinema nonstop, which mostly is the case...
	begin
		raiserror('Ora introdusa nu este valida! Va rugam introduceti o ora sub formatul hh:mm; orele din intervalul 02:01 - 09:59 nu sunt valide!', 10, 1)
		return
	end
	
	insert into Filmliste values
	(@Titel, @Regisseur, @Kino, @Telefonnummer, @Zeit)

end
go

exec validatedInsertion 'The Hobbit', 'Jackson', 'Cinema City', 441111, '11:30'

exec validatedInsertion 'Terminator', 'Jackson!', 'Cinema City', 441111, '11:30'
exec validatedInsertion 'Lala Land', 'Jackson2', 'Cinema City', 441111, '09:30'
exec validatedInsertion 'Deadpool', 'Jackson', 'Cinema City', 441111, '12:00'

exec validatedInsertion 'Blueberry', 'Morelli', 'Cinema City', 441111, '09:30'
exec validatedInsertion 'Citizen Kane', 'Morelli', 'Cinema City', 441111, '03:00'
exec validatedInsertion 'Lala Land', 'Morelli', 'Cinema City', 441111, '11:00'


drop table Filmliste
create table Filmliste(
Titel varchar(100),
Regisseur varchar(50),
Kino varchar(50),
Telefonnummer bigint,
Zeit time,
primary key (Titel, Kino, Zeit)
)

-- cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2 cerinta 2

-- trebuie sa ma mut pe lab1!!
create view [Sportivi si antrenamente] as
select s.CNP, s.nume, s.prenume, sub.specializare, a.ora_start, a.ora_final, l.denumire
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
join Subclub sub on sub.id_subclub = s.id_subclub

select * from [Sportivi si antrenamente];


create function getIntervalTrainings(@StartingHour time, @FinishingHour time) -- filtreaza
returns table					
as

	return
		select sa.nume, sa.prenume, sa.specializare, sa.ora_start, sa.ora_final
		from [Sportivi si antrenamente] sa
		where @StartingHour < sa.ora_start and sa.ora_final < @FinishingHour

go


select nume, prenume, specializare, ora_start from dbo.getIntervalTrainings('06:00','12:00')
-- order by specializare
union
select sa.nume, sa.prenume, sa.specializare, sa.ora_start 
from [Sportivi si antrenamente] sa
where sa.specializare = 'baschet'
order by specializare