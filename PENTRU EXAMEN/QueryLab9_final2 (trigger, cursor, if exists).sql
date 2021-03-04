--insert into triggers_log values
--(getdate(), 'proba', 'proba', -1)

drop trigger insert_trigger --
create trigger insert_trigger
on Persons
after insert, update, delete
as
begin

	declare @my_row_count int = @@ROWCOUNT
	select @my_row_count
		
	declare @activity varchar(100)

	if exists(SELECT * from inserted) and exists (SELECT * from deleted)
	begin
	    SET @activity = 'UPDATE';
	end

	if exists (Select * from inserted) and not exists(Select * from deleted)
	begin
		SET @activity = 'INSERT';
	end

	if exists(select * from deleted) and not exists(Select * from inserted)
	begin 
		SET @activity = 'DELETE';
	end

	insert into triggers_log values
	(getdate(), @activity, 'Persons', @my_row_count)
	
end
insert into Persons values
(7000210334546, 'Muntean', 'Ioan', 'mobile', 10, 1),
(7000210334547, 'Ganea', 'Tudor', 'mobile', 5, 2)
select * from triggers_log

insert into Persons values
(5000210330000, 'Popovici', 'Tudor', 'mobile', 5, 1)
select * from triggers_log

insert into Persons values
(6000210334547, 'Cristinar', 'Tudor', 'mobile', 5, 2),
(6000210335657, 'Bota', 'Tudor', 'mobile', 5, 1),
(6000210334578, 'Hritcu', 'Tudor', 'mobile', 5, 2)
select * from triggers_log

delete from Persons
where cnp = '7000210334546' or cnp = '7000210334547' 
select * from triggers_log

update Persons
set ani_experienta = 6
where ani_experienta = 5
select * from triggers_log

use lab9
select * from Persons
select * from triggers_log
drop table Persons
create table Persons(
cnp bigint primary key,
nume varchar(50),
prenume varchar(50),
domeniu varchar(50),
ani_experienta int,
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

select * from triggers_log


-- PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1 PANA AICI CERINTA 1


drop table Employee
create table Employee(
cnp bigint,
nume varchar(50),
prenume varchar(50),
departament varchar(50),
salariu float
)

insert into Employee values
(5000210334546, 'Muntean', 'Ioan', 'mobile development', 100),
(5000210334547, 'Ganea', 'Tudor', 'mobile development', 100),
(5000210330000, 'Popovici', 'Tudor', 'web development', 100),
(6000210334547, 'Cristinar', 'Tudor', 'web development', 100),
(6000210335657, 'Bota', 'Tudor', 'marketing', 100),
(6000210334578, 'Hritcu', 'Tudor', 'marketing', 100)

drop procedure raise_salary
create procedure raise_salary(@departament varchar(50)) --raise este un numar pozitiv subunitar
as
begin
	if @departament = 'mobile development'
	begin
		update Employee set salariu = salariu + 0.15 * salariu where current of cursor_employees -- imi trebuie neaparat where "current of"-ul asta ca sa nu imi faca update global pe coloana salariu ( deci sa nu imi faca pe toate randurile )
	end
	else if @departament = 'web development'
	begin
		update Employee set salariu = salariu + 0.10 * salariu where current of cursor_employees
	end
	else if @departament = 'marketing'
	begin
		update Employee set salariu = salariu + 0.05 * salariu where current of cursor_employees
	end
end

select * from Employee

declare @departament varchar(50)

set nocount on
declare cursor_employees cursor for
	select departament from Employee
for update of salariu

open cursor_employees
fetch cursor_employees into @departament
while @@FETCH_STATUS = 0
begin

	exec raise_salary @departament
	
fetch cursor_employees into @departament
end
close cursor_employees
deallocate cursor_employees

select * from Employee
