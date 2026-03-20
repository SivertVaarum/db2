# db2
Prosjektoppgave til tdt4145

Vi endret på et par ting i schemaet, vi la til view helt nederst i schema.sql
Vi endret også på to tabeller:
- La til ID på `Prikk`, kan ikke gi to prikker samtidig, kan skje med automatisk prikkgivning
- Endret foreign key på `Deltatt` slik at det refererer til en `Booking`, altså brukeren må være påmeldt for å kunne delta
