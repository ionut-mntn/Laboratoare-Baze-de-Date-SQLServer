--insert into triggers_log values
--(getdate(), 'proba', 'proba', -1)

drop trigger insert_trigger --
create trigger insert_trigger
on Persons
after insert, update, delete
as
begin

	-- atentie! @@ROWCOUNT ASTA TREBUIE SA IL IAU LA INCEPUT INTR O VARIABILA DACA VREAU SA AIBA RELEVANTA LA FINAL IN INSERTUL IN log_triggers

	-- nu tre sa ii mai dai si "select @@ROWCOUNT"; iar daca declar intai variabila si apoi fac asignarea, adica nu fac totu intr o linie prin initializare, nu o sa mearga!! 
	declare @my_row_count int = @@ROWCOUNT -- declararea nu se considera ca statement? si atunci asta nu ar mai trebui sa functioneze..
	select @my_row_count
		
	declare @activity varchar(100)
	--select @@ROWCOUNT

	if exists(SELECT * from inserted) and exists (SELECT * from deleted) -- mi se pare mult mai eficient daca asta e primul if, nu celelalte doua!
	begin
	    SET @activity = 'UPDATE';
	end
	--select @@ROWCOUNT
	if exists (Select * from inserted) and not exists(Select * from deleted)
	begin
		SET @activity = 'INSERT';
	end
	--select @@ROWCOUNT
	if exists(select * from deleted) and not exists(Select * from inserted)
	begin 
		SET @activity = 'DELETE';
	end
	--select @@ROWCOUNT
	insert into triggers_log values
	(getdate(), @activity, 'Persons', @my_row_count) -- sau asa: select count * from inserted
	
end
insert into Persons values
(5000210334546, 'Muntean', 'Ioan', 'mobile', 10, 1),
(5000210334547, 'Muntean', 'Tudor', 'mobile', 5, 2),
(5000210334548, 'Muntean', 'Andrei', 'mobile', 5, 2)
/*
insert into Persons values
(5000210330000, 'Muntean', 'Tudor', 'mobile', 5, 2)

insert into Persons values
(6000210334547, 'Muntean', 'Tudor', 'mobile', 5, 2),
(6000210335657, 'Muntean', 'Tudor', 'mobile', 5, 2),
(6000210334578, 'Muntean', 'Tudor', 'mobile', 5, 2),
(6000210334599, 'Muntean', 'Tudor', 'mobile', 5, 2)
*/

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


