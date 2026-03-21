SELECT avmeldt_tidspunkt 
FROM Booking 
WHERE brukerID = :brukerID AND gruppetimeID = :gruppetimeID
