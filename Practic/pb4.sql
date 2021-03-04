use Praktik2

select l.Titel, l.Dauer from Lied l
join BandLied bl on l.Id = bl.LiedId
join Band b on bl.BandId = b.Id
where b.BandName = 'Fara Zahar'

intersect

select l.Titel, l.Dauer from Lied l
join BandLied bl on l.Id = bl.LiedId
join Band b on bl.BandId = b.Id
where b.BandName = 'Vita de Vie'
