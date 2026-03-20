# db2
Prosjektoppgave til tdt4145

## Endring i schema
Vi endret på et par ting i schemaet, vi la til view helt nederst i schema.sql
Vi endret også på to tabeller:
- La til ID på `Prikk`, kan ikke gi to prikker samtidig, kan skje med automatisk prikkgivning
- Endret foreign key på `Deltatt` slik at det refererer til en `Booking`, altså brukeren må være påmeldt for å kunne delta

## Hvordan kjøre
Hvis du skal legge til noe data må du huske å kjøre `PRAGMA foreign_keys = ON` først for å slå på foreign keys
Dette er allerede gjort i de relevante sql og python scriptsene
```sh
cd sql # her sql scriptsene ligger
sqlite3 databasefil.db < setup.sql # setter opp databasen med schema, triggers og data
sqlite3 databasefil.db < history-johnnny.sql # finner historikken til johnny 
cd ../python # går til python mappen, må være her for å kjøre python filene
python booking.py # resten av brukstilfellene er her
```

