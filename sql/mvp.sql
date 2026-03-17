WITH månedsteller AS (
    SELECT b.id,
           b.fornavn || ' ' || b.etternavn AS navn,
           COUNT(*) AS antall
    FROM Bruker b
    JOIN Deltatt d ON b.id = d.brukerID
    WHERE d.oppmøtt_tidspunkt >= date(:month)
      AND d.oppmøtt_tidspunkt < date(:month, '+1 month')
    GROUP BY b.id, b.fornavn, b.etternavn
)
SELECT navn, antall
FROM månedsteller
WHERE antall = (SELECT MAX(antall) FROM månedsteller);
