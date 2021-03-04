-- asta de aici sa nu fie bagata in seama !!!
create function getSubclubSportivNames (@Nume_Subclub varchar(50))

returns table

as

        return

                select s.nume, s.prenume

                from Sportiv s

                join Subclub sub on  s.id_subclub = sub.id_subclub -- atentie!! am si sportivi care momentan nu sunt inscrisi la vreun subclub ( deci trebuie -- sa imi faca legatura asta !!

                where sub.nume = @Nume_Subclub

-----------------------------------------------------------------------

select * from dbo.getSubclubSportivNames('FC Dinamo Bucuresti')

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- DE AICI IN JOS LAB 7

/*
create table VersionNr(
current_version int identity(1,1) primary key
)
*/

create table Sample_Persons(
cnp bigint primary key,
nume varchar(50),
prenume varchar(50),
domeniu varchar(50),
ani_experienta int,
--address_id varchar(50) foreign key references Adresa
address_id varchar(50)
)
drop table Sample_Persons

create table Adresa(
id_adresa varchar(50) primary key,
tara varchar(50),
judet varchar(50),
localitate varchar(50),
strada varchar(50),
numar varchar(50)
)
drop table Adresa

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
drop table VersionNr
drop table History
drop table rollbackHelper
create table VersionNr(
current_version int primary key
)
insert into VersionNr values(0)
create table History(
id int identity(1,1),
query varchar(MAX)
)
create table rollbackHelper(
id int identity(1,1) primary key,
query varchar(MAX) 
)
--exec createTable 'proba', 'ceva', 'int'

select * from History
select * from rollbackHelper
select * from VersionNr

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
create table VersionNr(
current_version int primary key
)
drop table VersionNr
--insert into VersionNr values(null)
--insert into VersionNr values(1)
insert into VersionNr values(0)

create table History(
id int identity(1,1),
query varchar(MAX)
)
drop table History

-- in rollbackHelper voi avea istoricul comenzilor de facut la intoarcere prin versiuni ( ma va ajuta sa navighez de la o versiune mai mare spre una mai veche )
create table rollbackHelper(
id int identity(1,1) primary key,
query varchar(MAX) 
)
drop table rollbackHelper

select * from History
select * from rollbackHelper
select * from VersionNr
-========================================================================================================================
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
	set @oldType = (select top 1 data_type from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Adresa' and column_name = 'numar' order by ORDINAL_POSITION)
	--print oldType -- vad ca merge si fara paranteze
	print (@oldType)	
	select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Sample_Persons' and column_name = 'ani_experienta' order by ORDINAL_POSITION

	declare @oldTypeMaxChar as varchar(50)
	set @oldTypeMaxChar = (select top 1 CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Sample_Persons' and column_name = 'ani_experienta') -- uneori sunt foarte importante parantezele!! cum e aici cazul
--	@oldTypeMaxChar = select top CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Sample_Persons' and column_name = 'ani_experienta'
--	select @oldTypeMaxChar = CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Sample_Persons' and column_name = 'ani_experienta'

	set @rollbackQuery = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @oldType
	insert into rollbackHelper values(@rollbackQuery)


	print (@sqlQuery)
	exec (@sqlQuery)

	end
go
exec changeColumnType 'Sample_Persons', 'ceva', 'float'
-- pentru aceasta procedura, pentru rollback se va apela aceeasi procedura
===========================================================================================================================================================================================













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
current_version int primary key
)
insert into VersionNr values(0)
create table History(
id int identity(1,1),
query varchar(MAX)
)
create table rollbackHelper(
id int identity(1,1) primary key,
query varchar(MAX) 
)
select * from History
select * from rollbackHelper
select * from VersionNr

drop table proba
exec createTable 'proba', 'ceva', 'int' -- pot incerca un try-except in procedura ca sa nu imi puna in tabele dar sa imi dea eroare la creare
select * from History
select * from rollbackHelper
select * from VersionNr

exec addColumn 'Sample_persons', 'ceva', 'int'
select * from History
select * from rollbackHelper
select * from VersionNr

exec addFK 'Sample_Persons', 'Sample_Persons_Address__FK', 'address_id', 'Adresa', 'id_adresa' 
select * from History
select * from rollbackHelper
select * from VersionNr




===========================================================================================================================================================================================
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
returns varchar(50)
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @constraintName

	return @sqlQuery

	end
go
print dbo.createDefaultConstraintRollback ('Sample_Persons', 'default_constraint_ceva')
===========================================================================================================================================================================================

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
========================================================================================

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

-- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN-- PANA AICI E BUN
-- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN-- PANA AICI E BUN
-- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN-- PANA AICI E BUN
-- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN-- PANA AICI E BUN
-- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN -- PANA AICI E BUN-- PANA AICI E BUN

