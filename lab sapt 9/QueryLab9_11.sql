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
	declare @my_row_count int = @@ROWCOUNT -- declararea nu se considera ca statement? si atunci asta nu ar mai trebui sa functioneze... e misto tho ca functioneaza;
	-- banuiesc ca initializare le face cumva simultan declararea cu asignarea de valoare initial
	select @my_row_count
		
	declare @activity varchar(100)

	if exists(SELECT * from inserted) and exists (SELECT * from deleted) -- mi se pare mult mai eficient daca asta e primul if, nu celelalte doua!
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
	(getdate(), @activity, 'Persons', @my_row_count) -- sau asa: select count * from inserted
	
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
/*
insert into Employee values
(5000210334546, 'Muntean', 'Ioan', 'mobile development', 5000),
(5000210334547, 'Ganea', 'Tudor', 'mobile development', 5000),
(5000210330000, 'Popovici', 'Tudor', 'web development', 3800),
(6000210334547, 'Cristinar', 'Tudor', 'web development', 3800),
(6000210335657, 'Bota', 'Tudor', 'marketing', 3000),
(6000210334578, 'Hritcu', 'Tudor', 'marketing', 3000)
*/
insert into Employee values
(5000210334546, 'Muntean', 'Ioan', 'mobile development', 100),
(5000210334547, 'Ganea', 'Tudor', 'mobile development', 100),
(5000210330000, 'Popovici', 'Tudor', 'web development', 100),
(6000210334547, 'Cristinar', 'Tudor', 'web development', 100),
(6000210335657, 'Bota', 'Tudor', 'marketing', 100),
(6000210334578, 'Hritcu', 'Tudor', 'marketing', 100)

-- echipe cu baieti si fete si sa fac fetch relative??
drop procedure raise_salary
--create procedure raise_salary(@departament varchar(50), @salariu float output) --raise este un numar pozitiv subunitar
create procedure raise_salary(@departament varchar(50)) --raise este un numar pozitiv subunitar
as
begin
	if @departament = 'mobile development'
	begin
		-- set @salariu = @salariu + 0.15 * @salariu
		update Employee set salariu = salariu + 0.15 * salariu where current of cursor_employees
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

--print 5/100.0

-- de mutat in procedura update-ul !!!

select * from Employee

declare @departament varchar(50),
		@salariu float -- declar variabilele in care fac fetchul

set nocount on -- nuj daca am nevoie si de asta..
declare cursor_employees cursor for
	select departament, salariu from Employee
for update of salariu -- aici e bine asa?

open cursor_employees
fetch cursor_employees into @departament, @salariu
while @@FETCH_STATUS = 0 -- simbolizeaza fetch reusit
begin

	exec raise_salary @departament -- nu mai aveam nevoie si de salariu in fetch!!
	
fetch cursor_employees into @departament, @salariu -- actualizez fetchul
end
close cursor_employees
deallocate cursor_employees

select * from Employee
