create procedure createTable(@tableName varchar(25), @columnName varchar(25), @columnType varchar(25))
as
	begin

	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'create table ' + @tableName + '(' + @columnName + ' ' + @columnType + ' primary key)'
	
	insert into History values(@sqlQuery)
	declare @rollbackQuery as varchar(MAX)
	set @rollbackQuery = dbo.createTableRollback(@tableName)
	insert into rollbackHelper values(@rollbackQuery)

	update VersionNr 
	set current_version = current_version + 1
	where current_version = (select top 1 current_version from VersionNr order by current_version)

	print (@sqlQuery)
	exec (@sqlQuery)

	end
go
exec createTable 'proba2', 'ceva', 'int'
select * from History
select * from rollbackHelper
select * from VersionNr

CREATE function createTableRollback(@tableName varchar(20))
returns varchar(50)
as
	begin
		declare @sqlQuery as varchar(MAX)
		set @sqlQuery = 'drop table ' + @tableName
		return @sqlQuery
	end
go
print dbo.createTableRollback('proba')
--=========================================================================================================================================================================================


========================================================================================
create procedure addColumn(@tableName varchar(25), @newColumnName varchar(25), @newColumnType varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' add ' + @newColumnName + ' ' + @newColumnType -- ! LA ADD E FARA "ADD COLUMN" !

	insert into History values(@sqlQuery)
	declare @rollbackQuery as varchar(MAX)
	set @rollbackQuery = dbo.addColumnRollback(@tableName, @newColumnName)
	insert into rollbackHelper values(@rollbackQuery)

	update VersionNr 
	set current_version = current_version + 1
	where current_version = (select top 1 current_version from VersionNr order by current_version)


	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec addColumn 'Sample_persons', 'ceva', 'int'
select * from History
select * from rollbackHelper
select * from VersionNr


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
--=====================================================================================================================================================================================



===========================================================================================================================================================================================
create procedure changeColumnType(@tableName varchar(25), @columnName varchar(25), @newType varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @newType -- atentie la spatii !!

	
	insert into History values(@sqlQuery)
	declare @rollbackQuery as varchar(MAX)

	update VersionNr 
	set current_version = current_version + 1
	where current_version = (select top 1 current_version from VersionNr order by current_version)

		
	declare @oldType as varchar(50)
	set @oldType = (select top 1 data_type from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and column_name = @columnName order by ORDINAL_POSITION)
	print @oldType

	declare @oldTypeMaxChar as varchar(50)
	select top 1 CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and column_name = @columnName
	set @oldTypeMaxChar = (select top 1 CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and column_name = @columnName) -- sau ani experienta -- uneori sunt foarte importante parantezele!! cum e aici cazul
	
	set @rollbackQuery = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @oldType -- daca oldType o sa fie null, nu imi afecteaza cu nimic acest string, acest query
	print @rollbackQuery

	if @oldTypeMaxChar is not null
	begin
		set @rollbackQuery = @rollbackQuery + '(' + @oldTypeMaxChar + ')'
	end

	insert into rollbackHelper values(@rollbackQuery)

	print (@sqlQuery)
	exec (@sqlQuery)

	end
go
exec changeColumnType 'proba', 'ceva', 'float'
select * from History
select * from rollbackHelper
select * from VersionNr
-- pentru aceasta procedura, pentru rollback se va apela aceeasi procedura
===========================================================================================================================================================================================


--===========================================================================================================================================================================================
create procedure createDefaultConstraint(@tableName varchar(25), @columnName varchar(25), @constraintName varchar(50), @defaultValue varchar(50))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' add constraint ' + @constraintName + ' default ' + ' ''' + @defaultValue + ''' for ' + @columnName -- atentie la spatii !!

	insert into History values(@sqlQuery)
	declare @rollbackQuery as varchar(MAX)
	set @rollbackQuery = dbo.createDefaultConstraintRollback(@tableName, @constraintName)
	insert into rollbackHelper values(@rollbackQuery)

	update VersionNr 
	set current_version = current_version + 1
	where current_version = (select top 1 current_version from VersionNr order by current_version)

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec createDefaultConstraint 'Sample_Persons', 'ani_experienta', 'default_constraint_ani_experienta', '10'
select * from History
select * from rollbackHelper
select * from VersionNr

-- e ok numele asa la procedura cu Rollback in coada? Sau e mai bn sa ii zic "dropDefaultConstraint"?
create function createDefaultConstraintRollback(@tableName varchar(25), @constraintName varchar(50))
returns varchar(Max) -- atentie la lungimi !!!!!!!!!!
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @constraintName

	return @sqlQuery

	end
go
print dbo.createDefaultConstraintRollback ('Sample_Persons', 'default_constraint_ceva')
===========================================================================================================================================================================================
===========================================================================================================================================================================================
create procedure addFK(@tableName varchar(25), @fkName varchar(50), @columnName varchar(25), @referencedTable varchar(25), @referencedTableColumn varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' add constraint ' + @fkName + ' foreign key (' + @columnName + ') references ' + @referencedTable + '(' + @referencedTableColumn + ')'-- ! LA ADD E FARA "ADD COLUMN" !

	insert into History values(@sqlQuery)
	declare @rollbackQuery as varchar(MAX)
	set @rollbackQuery = dbo.addFKRollback(@tableName, @fkName)
	insert into rollbackHelper values(@rollbackQuery)

	update VersionNr 
	set current_version = current_version + 1
	where current_version = (select top 1 current_version from VersionNr order by current_version)

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
--exec addFK 'Sample_persons', 'id_adresa', 'Adresa', 'address_id'
exec addFK 'Sample_Persons', 'Sample_Persons_Address__FK', 'address_id', 'Adresa', 'id_adresa' 
select * from History
select * from rollbackHelper
select * from VersionNr


create function addFKRollback(@tableName varchar(25), @fkName varchar(50))
returns varchar(MAX)
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @fkName

--	print (@sqlQuery)
	-- exec(@sqlQuery)

	return @sqlQuery

	end
go
print dbo.addFKRollback ('Sample_Persons', 'Sample_Persons_Address__FK')
========================================================================================

create procedure goToVersion(@desiredVersion int)
as
begin

	declare @currentVersion int
	set @currentVersion = (select top 1 current_version from VersionNr)

	-- daca e aceeasi versiune pot iesi imediat( ce fac eu mai jos ) sau sa arunc exceptie
	if @currentVersion = @desiredVersion
	begin
		print('Baza de date este deja la versiunea dorita')
		return
	end

	declare @queryToExecute as varchar(Max)
	if @currentVersion < @desiredVersion
	begin
		while @currentVersion != @desiredVersion
		begin
			set @currentVersion = @currentVersion + 1 -- aici intai incrementez versiunea
			set @queryToExecute = (select query from History where id = @currentVersion) -- pe inaintare in versiuni folosesc History
			print @queryToExecute
			exec (@queryToExecute) -- apoi execut 
		end
	
	end
	else
	begin 

		while @currentVersion != @desiredVersion
		begin
			set @queryToExecute = (select query from rollbackHelper where id = @currentVersion) -- pe mers inapoi in versiuni folosesc rollbackHelper
			print @queryToExecute
			exec (@queryToExecute) -- aici intai execut
			set @currentVersion = @currentVersion - 1 -- apoi actualizez versiunea
		end
	end 

	update VersionNr
	set current_version = @desiredVersion -- asta seteaza peste tot. ma gandesc ca pot folosi daca eu am oricum doar un field

end
go


drop table Sample_Persons
drop table Adresa

create table Sample_Persons(
cnp bigint primary key,
nume varchar(50),
prenume varchar(50),
domeniu varchar(50),
ani_experienta int,
--address_id varchar(50) foreign key references Adresa
address_id varchar(50)
)
create table Adresa(
id_adresa varchar(50) primary key,
tara varchar(50),
judet varchar(50),
localitate varchar(50),
strada varchar(50),
numar varchar(50)
)

drop table VersionNr
drop table History
drop table rollbackHelper
create table VersionNr(
current_version int primary key,
)
insert into VersionNr values(0)
create table History(
id int identity(1,1), -- poate sa fac primary key aici?
query varchar(MAX)
)
create table rollbackHelper(
id int identity(1,1) primary key,
query varchar(MAX) 
)
select * from VersionNr
select * from History
select * from rollbackHelper

drop table proba
exec createTable 'proba', 'ceva', 'int' -- pot incerca un try-except in procedura ca sa nu imi puna in tabele dar sa imi dea eroare la creare
select * from VersionNr
select * from History
select * from rollbackHelper

exec addColumn 'proba', 'altceva', 'int'
select * from VersionNr
select * from History
select * from rollbackHelper

exec changeColumnType 'proba', 'altceva', 'float'
select * from History
select * from rollbackHelper
select * from VersionNr


exec createDefaultConstraint 'Sample_Persons', 'ani_experienta', 'default_constraint_ani_experienta', '10'
select * from VersionNr
select * from History
select * from rollbackHelper

exec addFK 'Sample_Persons', 'Sample_Persons_Address__FK', 'address_id', 'Adresa', 'id_adresa' 
select * from VersionNr
select * from History
select * from rollbackHelper

exec goToVersion 3
select * from VersionNr
select * from History
select * from rollbackHelper

--exec goToVersion '5' -- asta merge
/*--astea in jos de ce nu merg?
exec goToVersion (5)
exec goToVersion('5')

exec (goToVersion 5)
exec (goToVersion '5')
exec (goToVersion (5))
exec (goToVersion ('5'))
*/
-- PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 PANA AICI LAB7 


create function addFKRollback(@tableName varchar(25), @fkName varchar(50))
returns varchar(MAX)
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @fkName

--	print (@sqlQuery)
	-- exec(@sqlQuery)

	return @sqlQuery

	end
go
print dbo.addFKRollback ('Sample_Persons', 'Sample_Persons_Address__FK')

/*
create table

create table Student(
cnp bigint primary key,
nume varchar(25),
prenume varchar(25),
inaltime,
greutate
)

create table Courses(
id_curs varchar(20) primary key
)

create table Enrolled(
cnp bigint,
id_curs varchar(20),
primary key (cnp, id_curs)
)

create function validateZeit() -- alfanumeric
returns int
as
	begin

	return iif(@var between '100' and , 1, 0)

	end
go
print dbo.validateAlphanumerical('ceva')

create procedure validatedInsert(@tableName, 

create table Filmliste(
Titel varchar(100),
Regisseur varchar(50),
Kino varchar(50),
Telefonnummer,
Zeit

)
*/
/*
create function probaf2()
returns bit
as
	begin

	return iif(10<5, 1, 0)

	end
go
print dbo.probaf2()
*/

create function validateName(@name)-- atributele se valideaza individual? e vreo problema daca unul depinde de altul?
returns 

create table Filmliste(
Titel varchar(100),
Regisseur varchar(50),
Kino varchar(50),
Telefonnummer bigint,
Zeit time
)

insert into Filmliste values
('The Hobbit', 'Jackson', 'Cinema City', '441111', '11:30') -- paranteze !!

/*
create function validateName(@Name varchar(50))
returns bit
as
	begin

	return iif(@Name not like '%[^a-zA-Z]%', 1, 0) -- sper ca e buna conditia

	end
go -- am impresia ca nu mai e nevoie de go-ul asta aici
print dbo.validateName('2')

create procedure validatedInsert(@tableName, @titel, @kino, @zeit)
as
	begin

	

	end
go
*/


/*
create function validateName2(@Name varchar(50))
returns int
as
begin
	if @Name not like '%[^a-zA-Z]%'
	begin
		return 1
	end
	return 0
end
go
print dbo.validateName2('Jackson')
*/

/*
create function validateName3(@Name varchar(50))
returns bit
as
	begin

	return iif(@Name not like '%[^a-zA-Z]%', 1, 0) -- sper ca e buna conditia

	end
go -- am impresia ca nu mai e nevoie de go-ul asta aici
print dbo.validateName3('J2J3')


create function validateTime(@Time time)
returns bit
as
begin
	
	return iif(@Time not between '02:00' and '10:00', 1, 0) -- a doua valoare trebuie neaparat sa fie 0 daca eu returnez tipul bit!

end
go
print dbo.validateTime('14:00:00')

select iif(@Time not between '02:00' and '10:00', 1, 0))
*/

/*
create procedure validatedInsertion(@Titel, @Regisseur, @Kino, @Telefonnummer, @Zeit)
as
begin

	begin try
		insert into 'Filmliste' values
		(@Titel, 
	end try
	begin catch

	end catch

end
go
*/
create function validateName3(@Name varchar(50))
returns bit
as
	begin

	return iif(@Name not like '%[^a-zA-Z]%', 1, 0) -- sper ca e buna conditia

	end
go -- am impresia ca nu mai e nevoie de go-ul asta aici
print dbo.validateName3('J2J3')


create function validateTime(@Time time)
returns bit
as
begin
	
	if @Time not between '02:00' and '10:00', 1, 0) -- a doua valoare trebuie neaparat sa fie 0 daca eu returnez tipul bit!

end
go
print dbo.validateTime('14:00:00')

select iif(@Time not between '02:00' and '10:00', 1, 0))
*/


create procedure validatedInsertion(@Titel, @Regisseur, @Kino, @Telefonnummer, @Zeit)
as
begin

	begin try
		insert into 'Filmliste' values
		(@Titel, 
	end try
	begin catch

	end catch

end
go
