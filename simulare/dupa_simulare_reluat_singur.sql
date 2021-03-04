drop table TrainType
create table TrainType(
ID int primary key,
[description] varchar(50)
)

drop table Train
create table Train(
ID int primary key,
[name] varchar(50),
trainTypeID int foreign key references TrainType,
)

drop table [Route]
create table [Route](
ID int primary key,
[name] varchar(50),
trainID int foreign key references Train,
trainStationID int foreign key references TrainStationSchedule
)


-- TrainStationSchedule reprezinta tabelul care imi modeleaza relatia 'many:many' intre Route si Train !
-- in tabelul many:any am FK-urile !!
drop table [TrainStationSchedule]
create table TrainStationSchedule(
ID int primary key,
arrivalTime time,
departureTime time
)


