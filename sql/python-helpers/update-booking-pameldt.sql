UPDATE Booking
SET avmeldt_tidspunkt = NULL, påmeldt_tidspunkt = :påmeldt
WHERE brukerID = :brukerID
AND gruppetimeID = :gruppetimeID
