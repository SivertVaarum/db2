SELECT tidspunkt, senter_navn, aktivitet_navn
FROM Gruppetime inner join Deltatt on Deltatt.gruppetimeID = Gruppetime.id inner join Bruker on Deltatt.brukerID = Bruker.id 
WHERE Gruppetime.tidspunkt > '2026-01-01 00:00:00' AND Bruker.epost like 'johnny@stud.ntnu.no'

