/*
1951005257062	Patraulea	Nicusor	kinetoterapie	18
1871020425274	Lupsor	Sami	fizioterapie	13
1861226519493	Ungureanu	Daniel	reflexoterapie	8
*/
-- Numele, prenumele, intervalul antrenamentului pentru sportivii care se antreneaza la un bazin sau la o sala polivalenta
select s.nume, s.prenume, a.ora_start, a.ora_final, l.denumire
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'bazin' or l.denumire = 'sala polivalenta'
order by l.denumire

(
select s.nume, s.prenume, a.ora_start, a.ora_final, l.denumire
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'bazin'
)
union
(
select s.nume, s.prenume, a.ora_start, a.ora_final, loc.denumire
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie loc on a.id_locatie = loc.id_locatie
where loc.denumire='sala polivalenta'
)
order by l.denumire -- aici stie cine e l.denumire pt ca el se uita in primul select. varianta comentata de mai jos nu merge
--order by loc.denumire
-- Numele, prenumele, intervalul antrenamentului pentru sportivii care se antreneaza la un bazin sau la o sala polivalenta



-- Numele, prenumele, CNP-ul si specializare sportivilor care: 
-- FIE: (sunt inscrisi la volei sau la inot) SI au intre 1.85m - 1.90m
-- FIE: (au densitatea osoasa intre 2 si 3) SI au masa musculara sub 63kg 
(
select s.nume as Nume, s.prenume as Prenume, s.CNP, sub.specializare
from Sportiv s
join Subclub sub on s.id_subclub = sub.id_subclub
where sub.specializare in ('volei', 'inot')
intersect
select s.nume as Nume, s.prenume as Prenume, s.CNP, sub.specializare
from Sportiv s
join Subclub sub on s.id_subclub = sub.id_subclub
where s.inaltime between 1.85 and 1.90
)
union
(
select s.nume as Nume, s.prenume as Prenume, s.CNP, sub.specializare
from Sportiv s
join Subclub sub on s.id_subclub = sub.id_subclub
where s.densitate_osoasa between 2 and 3
intersect
select s.nume as Nume, s.prenume as Prenume, s.CNP, sub.specializare
from Sportiv s
join Subclub sub on s.id_subclub = sub.id_subclub
where s.masa_musculara <= 63
)
order by sub.specializare AsC
-- Numele, prenumele, CNP-ul si specializare sportivilor care: 
-- FIE: (sunt inscrisi la volei sau la inot) SI au intre 1.85m - 1.90m
-- FIE: (au densitatea osoasa intre 2 si 3) SI au masa musculara sub 63kg 


-- Numele, prenumele, specializarea si intervalul in care se antreneaza sportivii inscrisi la polo sau handbal, mai putin sportivii care se antreneaza dupa ora 16:00
select s.nume, s.prenume, sub.specializare, a.ora_start from  
Sportiv s
join Subclub sub on sub.id_subclub = s.id_subclub
join Antrenament a on a.CNP = s.CNP
where sub.specializare in ('polo', 'handbal')
except
select s.nume, s.prenume, sub.specializare, a.ora_start from  
Sportiv s
join Subclub sub on sub.id_subclub = s.id_subclub
join Antrenament a on a.CNP = s.CNP
where a.ora_start between '16:00:00' and '23:00:00'
order by a.ora_start
-- Numele, prenumele, specializarea si intervalul in care se antreneaza sportivii inscrisi la polo sau handbal, mai putin sportivii care se antreneaza dupa ora 16:00

-- vreau CNP-ul, specializarea, tipul si intervalul antrenamentului si tipul de incinta in care se antreneaza fiecare sportiv care: incepe antrenamentul in intervalul 05:00 - 12:00 (prima parte a zilei) DAR nu sunt inscrisi la volei sau la fotbal
select s.CNP, sub.specializare, a.ora_start, a.ora_final, a.tip as 'Tip antrenament', l.denumire as 'Tip incinta'
from Sportiv s
join Antrenament a on a.CNP = s.CNP
join Subclub sub on sub.id_subclub = s.id_subclub
join Locatie l on l.id_locatie = a.id_locatie
where a.ora_start between '05:00:00' and '12:00:00' and sub.specializare not in ('volei', 'fotbal')
order by sub.specializare
-- vreau CNP-ul, specializarea, tipul si intervalul antrenamentului si tipul de incinta in care se antreneaza fiecare sportiv care: incepe antrenamentul in intervalul 05:00 - 12:00 (prima parte a zilei) DAR nu sunt inscrisi la volei sau la fotbal

-- Vreau CNP-ul, numele si prenumele tuturor membrilor din staff-ul tehnic care nu sunt antrenori tehnici
select mst.CNP, mst.nume, mst.prenume, mst.specializare
from Membru_staff_tehnic mst
where mst.specializare not in ( select specializare from Subclub ) -- eu am si specializari ( cum ar fi "kinetoterapie" care nu se gaseste
order by nume asc
-- Vreau CNP-ul, numele si prenumele tuturor membrilor din staff-ul tehnic care nu sunt antrenori tehnici


--========================================================================
--Numele si prenumele sportivilor care se antreneaza la o sala polivalenta, ordonate dupa ora de start
select s.nume, s.prenume, a.ora_start, a.ora_final--, l.denumire -- pot sa las sau nu asta
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'sala polivalenta'
order by a.ora_start


-- selecteaza-mi CNP-urile oricaror 5 sportivi care incep antrenamentul mai devreme de ora 8
select top(5) s.nume, s.prenume, s.CNP
from Sportiv s
where exists ( select a.ora_start, a.ora_final
				from Antrenament a
				where a.CNP = s.CNP and
				--where 
				a.ora_start <= '12:00:00'
				)
-- selecteaza-mi CNP-urile oricaror 5 sportivi care incep antrenamentul mai devreme de ora 8

-- numele tuturor antrenorilor si antrenamentele de specialitatea lor
/*
select s.nume, s.prenume from Sportiv s
from Antrenament a
--join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
except
(select s.nume, s.prenume -- pot sa las sau nu asta
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'stadion')
*/

-- selecteaza toate specializarile si afiseaza unde au sediile. Afiseaza si adresele la care nu se afla biroul vreunui club de o specializare anume.
select mst.specializare, a.*-- tot din a
from Membru_staff_tehnic mst
join Angajati ang on mst.CNP = ang.CNP
join Subclub sub on ang.id_subclub = sub.id_subclub
--right outer join Adresa a on sub.id_adresa = a.id_adresa
left outer join Adresa a on sub.id_adresa = a.id_adresa
order by mst.specializare
--where mst.specialitate = 'fotbal'

-- selecteaza toate specializarile si afiseaza unde au sediile. Afiseaza si adresele la care nu se afla biroul vreunui club de o specializare anume.
-- structura piramidala pt join-uri multiple !!

select a.oras, a.strada, a.numar, sub.specializare
from Adresa a
--join Subclub sub on a.id_adresa = sub.id_adresa
--right join Subclub sub on a.id_adresa = sub.id_adresa
left join Subclub sub on a.id_adresa = sub.id_adresa -- ! conteaza ordinea; scrise asa, adresa e in stanga si subclub e in dreapta !!

/*
select a.oras, a.strada, a.numar, sub.specializare
from Subclub sub
--join Subclub sub on a.id_adresa = sub.id_adresa
--right join Subclub sub on a.id_adresa = sub.id_adresa
left join Adresa a on a.id_adresa = sub.id_adresa	-- left sau right imi spune unde este ceea ce urmeaza!!
*/



-- nr de sportivi de la fiecare specializare cu mai mult de 2 sportivi; ordoneaza dupa cele mai numeroase specializari
select count(s.CNP) as 'Nr Sportivi', sub.specializare--,sub.nume
from Sportiv s
join Subclub sub on s.id_subclub = sub.id_subclub
group by sub.specializare--, sub.nume -- in group by aici ii zic dupa ce criteriu sa imi numere si "map-uiasca" CNP-urile
having count(s.CNP) > 2
order by count(s.CNP) desc -- sau: order by 'Nr Sportivi' desc
-- nr de sportivi de la fiecare specializare cu mai mult de 2 sportivi; ordoneaza dupa cele mai numeroase specializari

-- Afiseaza-mi cele mai devreme ore la care incep antrenamentele pentru fiecare tip, dar nu afisa tipurile cu ore de incepere mai devreme de 06:00; ordoneaza dupa  ...
select min(a.ora_start) as 'Cel mai devreme', a.tip
from Antrenament a
group by a.tip
having min(a.ora_start) >= '06:00:00' -- in having trebuie sa apara NEAPARAT ce nu apare in group by
order by min(a.ora_start) asc
-- Afiseaza-mi cele mai devreme ore la care incep antrenamentele pentru fiecare tip, dar nu afisa tipurile cu ore de incepere mai devreme de 06:00; ordoneaza dupa  ...

-- Greutatea medie, numarul sportivilor si specializarea, ordonate dupa specializare, daca greutatea medie este mai mare de 75
select avg(s.greutate) as greutate_medie, count(*) as 'Nr sportivi', sub.specializare
from Sportiv s
join Subclub sub on sub.id_subclub = s.id_subclub
group by sub.specializare -- incearca sa gandesti incepand de la group by! poate e mai usor
having avg(s.greutate) > 75
order by specializare
-- Greutatea medie, numarul sportivilor si specializarea, ordonate dupa specializare, daca greutatea medie este mai mare de 75


-- toti sportivii mai inalti decat sportivul cu greutatea cea mai mare
select * from Sportiv s
where s.inaltime > (select max(s.greutate) from Sportiv s)
-- toti sportivii mai inalti decat sportivul cu greutatea cea mai mare
select * from Sportiv s
where s.CNP like '?00???????????'



--========================================================================
/*
-- vreau inaltimea medie si numarul sportivilor care fac antrenamente la bazin,
select avg(s.inaltime) as inaltime_medie, COUNT(s.CNP) as nr_sportivi--, s.greutate
from Sportiv s
join Antrenament a on a.CNP = s.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'bazin'

--========================================================================

select min(s.greutate) as cel_mai_slab, s.nume, s.prenume
from Sportiv s
where s.densitate_osoasa < 3
group by (s.nume, s.prenume)

--========================================================================
select avg(s.inaltime) as inaltime_medie, COUNT(s.CNP) as nr_sportivi--, s.greutate
from Sportiv s
join Antrenament a on a.CNP = s.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'bazin'
group by s.greutate
having count(*) >=2
*/

-- toate numele subcluburilor care au cel putin un sportiv nascut in 2000
select sub.nume
from Subclub sub
--join
where sub.id_subclub = any ( select s.id_subclub from Sportiv s where s.cnp like '_00%' ) -- din cnp deduc data nasterii
-- toate numele subcluburilor care au cel putin un sportiv nascut in 2000

-- sportivii mai inalti decat toti sportivii de la inot
select s.CNP, s.nume, s.prenume
from Sportiv s
where s.inaltime > 
all( select s.inaltime -- atentie aici sa aiba si relevanta logic !! nu as fi putut compara cu greutatea, pentru ca eu altceva vreau in cazul de fata!
from Sportiv s
join Subclub sub on sub.id_subclub = s.id_subclub
where sub.specializare = 'inot'
)
-- sportivii mai inalti decat toti sportivii de la inot

-- vreau toate intervalele diferite de antrenament ( am unele intervale in care mai mult de 1 sportiv se antreneaza fix de la aceeasi ora de start pana la aceeasi ora de final )
--select count(a.id_antrenament) from Antrenament a -- nr de antrenamente
select distinct a.ora_start, a.ora_final
from Antrenament a
-- vreau toate intervalele diferite de antrenament ( am unele intervale in care mai mult de 1 sportiv se antreneaza fix de la aceeasi ora de start pana la aceeasi ora de final )

