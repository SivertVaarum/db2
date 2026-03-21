# db2
Prosjektoppgave til tdt4145

## Bruk av KI
Vi har ikke brukt KI, siden vi vil ha stort læringsutbytte

## Endring i schema
Vi endret på et par ting i schemaet, vi la til view helt nederst i schema.sql
Vi endret også på to tabeller:
- La til ID på `Prikk`, kan ikke gi to prikker samtidig, kan skje med automatisk prikkgivning
- Endret foreign key på `Deltatt` slik at det refererer til en `Booking`, altså brukeren må være påmeldt for å kunne delta

## Antakelser og forklaring av oppgaver
- Brukstilfelle 6: Dette implementeres utelukkende med triggers, så ingen python nødvendig. Hvis en bruker møter opp for sent, eller melder seg av for sent så får de automatisk prikk. Vi har et view som viser de som akkurat nå er utestengt. Det sjekkes at brukeren ikke er i utestengt når den prøver å melde seg på noe, sjekkes opp mot påmeldt tidspunkt. 
- Brukstilfelle 8: Vi antar at når to stykk går på samme gruppetime, så trener dem sammen. Vi tenker at for høye tall så vil dette være relevant, lite sannsynelighet for å tilfeldigvis havne på mange treninger sammen uten å koordinere

## Hvordan kjøre
Hvis du skal legge til noe data må du huske å kjøre `PRAGMA foreign_keys = ON` først for å slå på foreign keys
Dette er allerede gjort i de relevante sql og python scriptsene
```sh
cd sql # her sql scriptsene ligger
sqlite3 databasefil.db < setup.sql # setter opp databasen med schema, triggers og data, må bare kjøres en gang
sqlite3 databasefil.db < history-johnnny.sql # slik kjører du sql query script
cd ../py # går til python mappen, må være her for å kjøre python filene
python booking.py # slik kjører du python filene, disse tar input fra terminalen
```

### Hvordan kjøre brukstilfellene

1. Gjøres i insert_data.sql, blir automatisk kjørt av setup.sql
2. Kjør `booking.py` i python mappen
3. Kjør `registration.py` i python mappen
4. Kjør `weeklyschedule.py` i python mappen
5. Kjør `history-johnnny.sql` i sql mappen
6. Dette skjer automatisk med triggers, se `triggers.sql`
7. Kjør `mvp.py` i python mappen
8. Kjør `train_together.sql` i sql mappen
