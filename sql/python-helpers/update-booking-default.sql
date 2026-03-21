UPDATE Booking
SET avmeldt_tidspunkt = NULL, påmeldt_tidspunkt = CURRENT_TIMESTAMP
WHERE brukerID = :brukerID
AND gruppetimeID = :gruppetimeID
