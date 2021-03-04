/*
CREATE PROCEDURE getKursTitel(@Kredite int, @Number int output)
AS
	SELECT @Number = COUNT(*)
	FROM Kurse
	WHERE ECTS = @Kredite
GO

DECALRE @Nr int
SET @Nr = 0
exec getKursTitel 6, @Number=@Nr output
print @Nr
*/

/* care e tipul de date al coloanei
SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
     TABLE_NAME = 'Sample_Persons' AND 
     COLUMN_NAME = 'nume'
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

===========================================================================================================================================================================================
create procedure changeColumnType(@tableName varchar(25), @columnName varchar(25), @newType varchar(25))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @newType -- atentie la spatii !!

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec changeColumnType 'Sample_Persons', 'nume', 'varchar(25)'
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
exec createDefaultConstraint Sample_Persons, ani_experienta, constraint_proba, 0

--alter table Sample_Persons add constraint constraint_proba default  '0' for ani_experienta -- aici tipul meu de date este int...
/*
ALTER TABLE Sample_Persons
--  ALTER COLUMN ani_experienta DROP DEFAULT
drop 'constraint_proba';
*/
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
exec addFK 'Sample_Persons', 'Sample_Persons_Address__FK', 'address_id', 'Adresa', 'id_adresa' 

create procedure addFKRollback(@tableName varchar(25), @fkName varchar(50))
as
	begin
	declare @sqlQuery as varchar(MAX)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @fkName

	print (@sqlQuery)
	exec(@sqlQuery)

	end
go
exec addFKRollback 'Sample_Persons', 'Sample_Persons_Address__FK'
========================================================================================