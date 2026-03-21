SELECT id 
FROM Gruppetime 
WHERE aktivitet_navn = :aktivitet 
AND tidspunkt = :tidspunkt 
AND senter_navn = :STED 
AND sal_navn = :SAL
