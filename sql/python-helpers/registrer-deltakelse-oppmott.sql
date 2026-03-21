INSERT INTO Deltatt (gruppetimeID, brukerID, oppmøtt_tidspunkt)
SELECT :trening_id, id, :oppmøtt_tidspunkt
From Bruker
WHERE epost = :brukernavn
