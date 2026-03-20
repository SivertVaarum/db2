SELECT brukerID, tidspunkt, senter_navn
FROM Besøk INNER JOIN Bruker on Besøk.brukerID = Bruker.brukerID as 
ORDER BY tidspunkt