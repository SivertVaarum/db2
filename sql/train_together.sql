with temp as ( select b.epost, d.gruppetimeID
from Bruker b
join Deltatt d on b.id = d.brukerID
)

select t1.epost, t2.epost, COUNT(*) as antall
from temp t1
join temp t2 on t1.gruppetimeID = t2.gruppetimeID
where t1.epost < t2.epost -- den som er alfabetisk først er i venstre kolonne
group by t1.epost, t2.epost;
