select s.nume, s.prenume, a.ora_start, a.ora_final--, l.denumire
from Sportiv s
join Antrenament a on s.CNP = a.CNP
--join Locatie l on a.id_locatie = l.id_locatie
--where l.denumire = 'stadion'
--========================================================================
select s.nume, s.prenume, a.ora_start, a.ora_final, l.denumire
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'stadion'


-- vreau numele prenumele, CNP-ul si "specializarea" fiecarui spotiv cu inaltimea intre 1.75 si 1.90
(
select s.nume as Nume, s.prenume as Prenume, s.CNP, sub.specializare
from Sportiv s
--where s.id_subclub = 10 or s.id_subclub = 16 -- inscris la volei sau la inot
join Subclub sub on s.id_subclub = sub.id_subclub

intersect

select s.nume as Nume, s.prenume as Prenume, s.CNP, sub.specializare
from Sportiv s
join Subclub sub on s.id_subclub = sub.id_subclub
where s.inaltime between 1.85 and 1.90
)
union
(
select s.nume as Nume, s.prenume as Prenume, s.CNP
from Sportiv s
where s.densitate_osoasa between 2 and 3

intersect

select s.nume as Nume, s.prenume as Prenume, s.CNP
from Sportiv s
where s.masa_musculara <= 50
)

order by Prenume AsC

--========================================================================
--Numele si prenumele sportivilor care se antreneaza la o sala polivalenta, ordonate dupa ora de start
select s.nume, s.prenume, a.ora_start, a.ora_final--, l.denumire -- pot sa las sau nu asta
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'sala polivalenta'
order by a.ora_start


-- CNP-urile primilor 5 sportivi care incep antrenamentul mai devreme de oa 8
select s.nume, s.prenume, s.CNP
--select top(5) s.nume, s.prenume, s.CNP
from Sportiv s
where exists ( select a.ora_start, a.ora_final
				from Antrenament a
--				where a.CNP = s.CNP and
				--where 
				a.ora_start <= '12:00:00'
				)

-- numele tuturor antrenorilor si antrenamentele de specialitatea lor
/*
select s.nume, s.prenume from Sportiv s
from Antrenament a,
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
except
(select s.nume, s.prenume -- pot sa las sau nu asta
from Antrenament a
join Sportiv s on s.CNP = a.CNP
join Locatie l on a.id_locatie = l.id_locatie
where l.denumire = 'stadion')
*/

-- selecteaza toate specialitatile si afiseaza unde au sediile
select distinct mst.specialitate, a.* -- tot din a
from Membru_staff_tehnic mst
join Angajati ang on mst.CNP = ang.CNP
join Subclub sub on ang.id_subclub = sub.id_subclub
--right outer join Adresa a on sub.id_adresa = a.id_adresa
right outer join Adresa a on sub.id_adresa = a.id_adresa
order by mst.specialitate

--where mst.specialitate = 'fotbal'



















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
