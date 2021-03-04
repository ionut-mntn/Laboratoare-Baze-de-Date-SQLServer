drop table TrainType
create table TrainType(
[name] varchar(50) primary key,
[description] varchar(50)
)

drop table Train
create table Train(
id int primary key,
[name] varchar(50),
[type] varchar(50) foreign key references TrainType
)

drop table TrainStation
create table TrainStation(
id int primary key,
arriving_time time,
departure_time time
)

drop table [Route]
create table [Route](
id int primary key,
[name] varchar(50),
[train] varchar(50) foreign key references TrainType,
train_station int foreign key references TrainStation
)

insert into TrainType values
('de calatori', 'agrement'),
('de marfa', 'industrial')
delete from TrainType

insert into Train values
(1,'Mocanita Moldovita', 'de calatori'),
(2,'Mocanita Oltisorul', 'de calatori')
delete from Train

insert into TrainStation values
(1,'10:00:00', '10:05:00'),
(2,'10:10:00', '10:20:00')
delete from TrainStation

insert into [Route] values
(1, 'Bucovina', 'de calatori', 1),
(2, 'Valea Oltului', 'de calatori', 2)
delete from Route

