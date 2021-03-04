use S1

go

alter view Album_Gesamtdauer 
as
Select Album.titel, sum(Lied.dauer) as Gesamtdauer
from Album
inner join Lied on Lied.album=Album.album_id
group by Album.album_id, Album.titel

go 

Select * from Album_Gesamtdauer
Select * from Album