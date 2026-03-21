INSERT INTO Deltatt (gruppetimeID, brukerID)
SELECT :trening_id, id
From Bruker
WHERE epost = :brukernavn
