use ExempluPractic
go

-- view care contine titlul albumelor impreuna cu durata totala a fiecaruia
create or alter view [albumDurations] as
	select a.id, a.title, sum(s.duration) as total_duration from songInAlbum sa
		inner join Albums a on
		a.id = sa.album
		inner join Songs s on
		s.id = sa.song
		group by a.id, a.title
go

-- interogare cu detalii despre concertele unde canta X si nu canta Y
select * from Concerts c
inner join singsAtConcert sc on
c.id = sc.concert
-- concertele unde nu canta Y
where c.id not in (
	select sc2.concert from singsAtConcert sc2
	inner join Singers s on
	s.id = sc2.singer
	where s.name = 'Jeff Bezos'
)
-- dar canta X
and c.id in (
	select sc2.concert from singsAtConcert sc2
	inner join Singers s on
	s.id = sc2.singer
	where s.name = 'Elon Musk'
)

-- interogare cu concertele la care participa cei mai putini cantereti
select top 1 with ties concert, count(*) as participants from singsAtConcert
group by concert
order by participants asc
go

/* BONUS */
-- view care contin numele cantaretilor care canta la concertul de la medias si cluj
create or alter view [nameOfSingersAtConcerts] as
	select distinct s.name from singsAtConcert sa
	inner join Singers s
	on s.id = sa.singer
	where s.id IN (
		select singer from singsAtConcert sac
		inner join Concerts c on
		c.id = sac.concert
		where c.location = 'medias'
	)
	and s.id IN (
		select singer from singsAtConcert sac
		inner join Concerts c on
		c.id = sac.concert
		where c.location = 'cluj'
	)
go

select * from [nameOfSingersAtConcerts]

-- query care afiseaza numarul de singeri si numele concertului cu nr mai mare decat nr de singeri ai concertului de la sighisoara
select sac.concert, c.location, count(*) as number_singers from singsAtConcert sac
inner join Concerts c on
c.id = sac.concert
group by sac.concert, c.location
having count(*) > (
	select count(*) as number_singers from singsAtConcert sac
	inner join Concerts c on
	c.id = sac.concert
	group by sac.concert, c.location
	having c.location = 'sighisoara'
)

-- durata tuturor albumelor care au cel putin 2 melodii
select sa.album,a.title, sum(s.duration) as total_duration, count(*) as number_songs from songInAlbum sa
inner join Songs s on
s.id = sa.song
inner join Albums a on
a.id = sa.album
group by sa.album, a.title
having count(*) >= 2
order by sum(s.duration) asc

-- durata medie a unui album cu 2 songuri
select sa.album,a.title, avg(cast(s.duration as decimal (12,2))) as total_duration, count(*) as number_songs from songInAlbum sa
inner join Songs s on
s.id = sa.song
inner join Albums a on
a.id = sa.album
group by sa.album, a.title
having count(*) >= 2
order by avg(s.duration) asc

-- cantaretii care au tinut concert la cluj dar nu la medias
select * from singsAtConcert sac
inner join Concerts c on
c.id = sac.concert
where sac.singer IN (
	select sac.singer from singsAtConcert sac
	inner join Concerts c on
	c.id = sac.concert
	where c.location = 'sighisoara'
)
and sac.singer NOT IN (
	select sac.singer from singsAtConcert sac
	inner join Concerts c on
	c.id = sac.concert
	where c.location = 'medias'
)