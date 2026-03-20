SELECT tidspunkt, senter_navn, aktivitet_navn -- kan ikke befinne seg to steder samtidig, så er unikt
FROM Gruppetime inner join Deltatt on Deltatt.gruppetimeID = Gruppetime.id inner join Bruker on Deltatt.brukerID = Bruker.id 
WHERE Gruppetime.tidspunkt > '2026-01-01 00:00:00' AND Bruker.epost like 'johnny@stud.ntnu.no'

