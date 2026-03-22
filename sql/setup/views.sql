create view GruppeTimeSlutt as
select g.id, g.aktivitet_navn, g.tidspunkt as starttidspunkt, 
	datetime(g.tidspunkt, '+' || a.lengde_min || ' minutes') as sluttidspunkt, 
	g.senter_navn, g.sal_navn, g.instruktørID
from Gruppetime G
join Aktivitet a on g.aktivitet_navn = a.navn
;

create view SalOpptatt as

select senter_navn, sal_navn, starttidspunkt, sluttidspunkt
from Reservasjon

union all

select senter_navn, sal_navn, starttidspunkt, sluttidspunkt
from GruppetimeSlutt
;

-- viser alle som ikke har meldt seg av og fjerner ventelisten
create view GruppetimeDeltakere as
select b.gruppetimeID, b.brukerID
from Booking b
join Gruppetime g on b.gruppetimeID = g.id
join Sal s on (g.senter_navn = s.senter_navn and g.sal_navn = s.navn) 
where b.avmeldt_tidspunkt is null
and s.kapasitet > (
	select count(*) -- antall som har meldt seg på før
	from Booking b2
	where b2.avmeldt_tidspunkt is null
	and b2.gruppetimeID = b.gruppetimeID
	and (
		b2.påmeldt_tidspunkt < b.påmeldt_tidspunkt -- meldt seg på før
		or (b2.påmeldt_tidspunkt = b.påmeldt_tidspunkt and b2.brukerID < b.brukerID) -- meldt seg på samtidig, går på brukerID
	)
);

-- viser alle på ventelisten
create view Venteliste as
select b.gruppetimeID, b.brukerID
from Booking b 
where b.avmeldt_tidspunkt is null
and not exists (
	select 1 
	from GruppetimeDeltakere g 
	where g.gruppetimeID = b.gruppetimeID
	and g.brukerID = b.brukerID
);

-- ikke møtt enda
create view IkkeMøtt as
select brukerID, gruppetimeID
from GruppetimeDeltakere g
where not exists (
	select 1
	from Deltatt d
	where d.gruppetimeID = g.gruppetimeID
	and d.brukerID = g.brukerID
);

-- Alle offentlige gruppetimer
create view OffentligeGruppetimer as
select *
from Gruppetime
where tidspunkt <= datetime(CURRENT_TIMESTAMP, '+48 hours');

create view MVP as
WITH månedsteller AS (
    SELECT b.id,
           b.fornavn || ' ' || b.etternavn AS navn,
           COUNT(*) AS antall,
		   STRFTIME('%Y-%m', d.oppmøtt_tidspunkt) as årmåned
    FROM Bruker b
    JOIN Deltatt d ON b.id = d.brukerID
    GROUP BY b.id, b.fornavn, b.etternavn, årmåned
)
SELECT mt.navn, mt.antall, mt.årmåned
FROM månedsteller as mt
WHERE mt.antall = (SELECT MAX(m.antall) FROM månedsteller as m WHERE mt.årmåned = m.årmåned);

