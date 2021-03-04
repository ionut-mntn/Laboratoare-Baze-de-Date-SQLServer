use Praktik3

select b.BandName, count(*) from Band b
join ......

group by g.GenreName
having count(*) 