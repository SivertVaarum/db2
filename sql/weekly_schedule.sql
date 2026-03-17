SELECT aktivitet_navn, tidspunkt, senter_navn
FROM Gruppetime
WHERE tidspunkt >= :startdato
    AND tidspunkt < date(:startdato, '+7 days')
ORDER BY tidspunkt;