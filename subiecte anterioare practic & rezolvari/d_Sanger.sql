use S1
 

Select  Konzert_Sanger.id_konzert 
from Konzert_Sanger
group by id_konzert
having count(nume)= (Select top 1 count(*)  from Konzert_Sanger 
														group by Konzert_Sanger.id_konzert
														order by count(nume))




