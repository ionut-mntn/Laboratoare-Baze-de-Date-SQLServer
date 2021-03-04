use ExempluPractic

-- freiwillige which participated in projekte and campaigns
select * from Freiwillige
where id in (select freiwillige from participatesToCampaign)
	  and
	  id in (select freiwillige from participatesToProjekt)
go

-- view with each persons number of projects in which it participated ordered by number projects
create or alter view [persons_projekte] as
	select f.id, f.name, count(*) as number_projects from participatesToProjekt p
	inner join Freiwillige f on
	p.freiwillige = f.id
	group by f.id, f.name
	order by count(*) desc offset 0 rows 
go

select * from [persons_projekte]

-- query that prints projects with number_participants > number_participans in all campaigns
select p.id, p.name, count(*) as participants from Projekte p
inner join participatesToProjekt pp on
p.id = pp.projekt
group by p.id, p.name
having count(*) > ALL (
	select count(*) as number_participants from Spendenaktion s
	inner join participatesToCampaign pc on
	s.id = pc.spendenAktion
	group by s.id
)