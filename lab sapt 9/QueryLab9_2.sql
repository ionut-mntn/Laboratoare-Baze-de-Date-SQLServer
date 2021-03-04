drop table Persons
create table Persons(
cnp bigint primary key,
nume varchar(50),
prenume varchar(50),
domeniu varchar(50),
ani_experienta int,
--address_id varchar(50) foreign key references Adresa
address_id varchar(50)
)

drop table triggers_log
create table triggers_log(
id int identity(1,1),
day_time datetime,
[type] varchar(10),
table_name varchar(100),
no_affected_rows int
)

insert into triggers_log values
(getdate(), 'proba', 'proba', -1)

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

insert into triggers_log values
(getdate(), 'proba', 'proba', -1)



drop trigger insert_trigger
create trigger insert_trigger
on Persons
instead of insert -- 
as
begin

	
	
	declare @nume_validat varchar(50) -- aici as fi putut incerca sa ii iau tipul daca as fi creat un trigger generic.. dar exista triggere generice?

	if @nume_validat = '-1'
	begin
		raiserror('Numele introdus nu este valid! Va rugam introduceti un nume format doar din caractere alfabetice!', 10, 1)
		return 
	end

	declare @prenume_validat varchar(50) -- aici as fi putut incerca sa ii iau tipul daca as fi creat un trigger generic.. dar exista triggere generice?
	set @prenume_validat = dbo.validateName(
	if @prenume_validat = '-1'
	begin
		raiserror('Prenumele introdus nu este valid! Va rugam introduceti un prenume format doar din caractere alfabetice!', 10, 1)
		return 
	end

	/*
	insert into Persons values(
	select cnp from inserted, -- where cnp nujce...
	@nume_validat,
	@prenume_validat,
	select cnp from inserted,
	)
	*/
	/*
	declare @affected_rows_number int
	select * from inserted
	set @affected_rows_number = select count(*) from inserted
	*/
	insert into triggers_log values
	(getdate(), 'insert', 'Persons', @@ROWCOUNT -- sau asa: select count * from inserted
	
end
insert into Persons values
(5000210334546, 'Muntean', 'Ioan', 'mobile', 10, 1),
(5000210334547, 'Muntean', 'Tudor', 'mobile', 5, 2)



