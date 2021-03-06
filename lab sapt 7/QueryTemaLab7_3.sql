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


-========================================================================================================================
create procedure createTable(@tableName varchar(25), @columnName varchar(25), @columnType varchar(25))
as
	begin

	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'create table ' + @tableName + '(' + @columnName + ' ' + @columnType + ' primary key)'
	
	insert into History values('drop table', @tableName)

	print (@sqlQuery)
	exec (@sqlQuery)

	end
go
exec createTable 'proba', 'ceva', 'int'

CREATE PROCEDURE createTableRollback(@tableName varchar(20)) as
	begin
		declare @sqlQuery as varchar(MAX)
		set @sqlQuery = 'drop table ' + @tableName
		print(@sqlQuery)
		exec(@sqlQuery)
	end
go
exec createTableRollback 'proba'
--=========================================================================================================================================================================================



===========================================================================================================================================================================================
CREATE PROCEDURE createTable2(@tableName varchar(20)) as
	begin
		declare @sqlQuery as varchar(MAX)
		set @sqlQuery = 'create table '+@tableName+' (id int NOT NULL PRIMARY KEY)'
		print(@sqlQuery)
		exec(@sqlQuery)
	end
go
exec createTable2 'proba2'

CREATE PROCEDURE createTable2Rollback(@tableName varchar(20)) as
	begin
		declare @sqlQuery as varchar(MAX)
		set @sqlQuery = 'drop table ' + @tableName
		print(@sqlQuery)
		exec(@sqlQuery)
	end
go
exec createTable2Rollback 'proba2'
===========================================================================================================================================================================================


===========================================================================================================================================================================================
create procedure changeColumnType(@tableName varchar(25), @columnName varchar(25), @newType varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @newType -- atentie la spatii !!

	print (@sqlQuery)
	exec (@sqlQuery)

	end
go
exec changeColumnType 'Sample_Persons', 'ceva', 'int' --float
-- pentru aceasta procedura, pentru rollback se va apela aceeasi procedura
===========================================================================================================================================================================================

===========================================================================================================================================================================================
create procedure createDefaultConstraint(@tableName varchar(25), @columnName varchar(25), @constraintName varchar(50), @defaultValue varchar(50))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' add constraint ' + @constraintName + ' default ' + ' ''' + @defaultValue + ''' for ' + @columnName -- atentie la spatii !!

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec createDefaultConstraint Sample_Persons, ceva, default_constraint_ceva, 10

-- e ok numele asa la procedura cu Rollback in coada? Sau e mai bn sa ii zic "dropDefaultConstraint"?
create procedure DefaultConstraintRollback(@tableName varchar(25), @constraintName varchar(50))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @constraintName

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec DefaultConstraintRollback 'Sample_Persons', 'default_constraint_ceva'
===========================================================================================================================================================================================

========================================================================================
create procedure addColumn(@tableName varchar(25), @newColumnName varchar(25), @newColumnType varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' add ' + @newColumnName + ' ' + @newColumnType -- ! LA ADD E FARA "ADD COLUMN" !

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec addColumn 'Sample_persons', 'ceva', 'int'


create procedure addColumnRollback(@tableName varchar(25), @ColumnName varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop column ' + @ColumnName

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec addColumnRollback 'Sample_persons', 'ceva'
========================================================================================

create procedure addFK(@tableName varchar(25), @fkName varchar(50), @columnName varchar(25), @referencedTable varchar(25), @referencedTableColumn varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' add constraint ' + @fkName + ' foreign key (' + @columnName + ') references ' + @referencedTable + '(' + @referencedTableColumn + ')'-- ! LA ADD E FARA "ADD COLUMN" !

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
--exec addFK 'Sample_persons', 'id_adresa', 'Adresa', 'address_id'
exec addFK 'Sample_Persons', 'Sample_Persons__Address_FK', 'address_id', 'Adresa', 'id_adresa' 

create procedure addFKRollback(@tableName varchar(25), @fkName varchar(50))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @fkName

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec addFKRollback 'Sample_Persons', 'Sample_Persons__Address_FK'
========================================================================================


-- asta de aici sa nu fie bagata in seama !!!
create function getSubclubSportivNames (@Nume_Subclub varchar(50))
returns table
as
        return
                select s.nume, s.prenume
                from Sportiv s
                join Subclub sub on  s.id_subclub = sub.id_subclub -- atentie!! am si sportivi care momentan nu sunt inscrisi la vreun subclub ( deci trebuie -- sa imi faca legatura asta 
                where sub.nume = @Nume_Subclub
-----------------------------------------------------------------------
select * from dbo.getSubclubSportivNames('FC Dinamo Bucuresti')
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- DE AICI IN JOS LAB 7

create table VersionNr(
current_version int
)
drop table VersionNr
insert into VersionNr values( 0 ) -- versiunea zero e cum e la inceput


create table History(
id int identity(1,1) primary key,
param1 varchar(50),
param2 varchar(50),
param3 varchar(50),
param4 varchar(50),
param5 varchar(50),
param6 varchar(50),
param7 varchar(50),
param8 varchar(50),
param9 varchar(50),
param10 varchar(50),
)
drop table History

/*
insert into History values -- nu e ca la create table, nu mai trebuie parantezele alea de inceput!!
('a'), ('b')

delete from History
where id = 2
*/

/*
CREATE FUNCTION ReturnSite
( @site_id INT )

RETURNS VARCHAR(50)

AS

BEGIN

   DECLARE @site_name VARCHAR(50);

   IF @site_id < 10
      SET @site_name = 'TechOnTheNet.com';
   ELSE
      SET @site_name = 'CheckYourMath.com';

   RETURN @site_name;

END;
*/
/*
create function createTableee (@tableName varchar(25), @columnName varchar(25), @columnType(25))
returns varchar(50) as
begin

	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'create table ' + @tableName + '(' + @columnName + ' ' + @columnType + ' primary key)';

	print(sqlQuery);

	return @sqlQuery;

end;
*/

-- in History voi avea istoricul comenzilor facute la inaintere prin versiuni ( ma va ajuta sa navighez de la o versiune mai veche spre o versiune mai recenta )
create table History(
id int identity(1,1),
query varchar(50)
)
drop table History

-- in rollbackHelper voi avea istoricul comenzilor de facut la intoarcere prin versiuni ( ma va ajuta sa navighez de la o versiune mai mare spre una mai veche )
create table rollbackHelper(
id int identity(1,1) primary key,
query varchar(50)
)

create function fCreateTable(@tableName varchar(25), @columnName varchar(25), @columnType varchar(25))
returns varchar(50)
as
	begin

	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'create table ' + @tableName + '(' + @columnName + ' ' + @columnType + ' primary key)'
	
	--print (@sqlQuery) -- nuj dc nu merge dar verific ca mai jos
	--exec (@sqlQuery)

	-- aici e tot spielu; care nu merge din pacate....
	-- insert into rollbackHelper values(select dbo.fCreateTableRollback(@tableName))


	return @sqlQuery

	end
select dbo.fCreateTable('proba', 'ceva', 'int')

CREATE function fCreateTableRollback(@tableName varchar(20))
returns varchar(50)
as
	begin
		
		declare @sqlQuery as varchar(MAX)-- mergea si fara 'as'

		declare @columnName varchar(25) 
		declare @columnType varchar(25)

		/*
--		select c.[name], c.[type]
		select c.name, c.type
		from sys.columns c
		inner join sys.tables t on t.id = c.table_id and t.name = 'meta';
		*/

		/*
		declare @aux table( columnName varchar(50), clumnType varchar(50) )
		insert into @aux values( 
		SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where
		table_schema = 'proba_lab6' and table_name = @tableName
		)
		*/
		
		declare @columnName varchar(50)
		set @columnName = SELECT COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where table_schema = 'proba_lab6' and table_name = @tableName
		
		
		declare @columnType varchar(50)
--		set @columnType = SELECT DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where table_schema = 'proba_lab6' and table_name = @tableName
		set @columnType = SELECT DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where table_name = 'Adresa'



		declare @nr_max_char
		set @nr_max_char = SELECT * from INFORMATION_SCHEMA.COLUMNS where table_schema = 'proba_lab6' and table_name = 'Adresa'
		set @columnType = @columnType + @nr_max_char
		SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE table = 'SourceView'

		select column_name, data_type, character_maximum_length    
  from information_schema.columns  
 where table_name = 'Adresa'

--		insert into History values

		set @sqlQuery = 'drop table ' + @tableName

		return @sqlQuery

	end
go -- fara go?
/*
SELECT * from INFORMATION_SCHEMA.COLUMNS where
		table_schema = 'proba_lab6' and table_name = 'Sample_Persons'
*/
print(createTable('PROBA', 'ceva', 'int'))

/*
select  
        s.[name]            'Schema',
        t.[name]            'Table',
        c.[name]            'Column',
        d.[name]            'Data Type',
        c.[max_length]      'Length',
        d.[max_length]      'Max Length',
        d.[precision]       'Precision',
        c.[is_identity]     'Is Id',
        c.[is_nullable]     'Is Nullable',
        c.[is_computed]     'Is Computed',
        d.[is_user_defined] 'Is UserDefined',
        t.[modify_date]     'Date Modified',
        t.[create_date]     'Date created'
from        sys.schemas s
inner join  sys.tables  t
on s.schema_id = t.schema_id
inner join  sys.columns c
on t.object_id = c.object_id
inner join  sys.types   d
on c.user_type_id = d.user_type_id
where c.name like '%ColumnName%'
*/