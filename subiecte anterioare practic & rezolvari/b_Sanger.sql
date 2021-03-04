use S1

Select ort, datum, zeit from Konzert
inner join Konzert_Sanger on Konzert.id_konzert=Konzert_Sanger.id_konzert
where Konzert_Sanger.nume='Rammstein' 
except 
Select ort, datum, zeit from Konzert
inner join Konzert_Sanger on Konzert.id_konzert=Konzert_Sanger.id_konzert
where Konzert_Sanger.nume='Jazzrausch' 

-- cheia 
