# db2
Prosjektoppgave til tdt4145

## Gruppeinfo
Gruppenr: 107

### Gruppemedlemmer
- Henrik Nordvik
- Sivert Lindblad Vårum
- Jonas Kristiansen


## Bruk av KI
Vi har ikke brukt KI, siden vi syntes det gir større læringsutbytte

## Endring i schema
Vi endret på et par ting i schemaet, vi la til view helt nederst i schema.sql
Vi endret også på to tabeller:
- La til ID på `Prikk`, kan ikke gi to prikker samtidig, kan skje med automatisk prikkgivning
- Endret foreign key på `Deltatt` slik at det refererer til en `Booking`, altså brukeren må være påmeldt for å kunne delta

## Antakelser og forklaring av oppgaver
- Brukstilfelle 6: Dette implementeres utelukkende med triggers, så ingen python nødvendig. Hvis en bruker møter opp for sent, eller melder seg av for sent så får de automatisk prikk. Vi har et view som viser de som akkurat nå er utestengt. Det sjekkes at brukeren ikke er i utestengt når den prøver å melde seg på noe, sjekkes opp mot påmeldt tidspunkt. Har også et script i sql mappen kalt `prikk-ikke-møtt.sql` som gir prikk til alle som ikke har møtt enda på en gitt gruppetime
- Brukstilfelle 8: Vi antar at når to stykk går på samme gruppetime, så trener dem sammen. Vi tenker at for høye tall så vil dette være relevant, altså lite sannsynlighet for å tilfeldigvis havne på mange treninger sammen uten å koordinere

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
```sh
db2/sql❯ sqlite3 databasefil.db < setup.sql
```
2. Kjør `booking.py` i python mappen

```sh
db2/py ❯ python booking.py
Oppgi epost: johnny@stud.ntnu.no
Oppgi aktivitet: Spin 8x3
Oppgi tid: 2026-03-18 19:30:00
Oppgi senter (default øya):
Oppgi sal (default sykkelsal):
Oppgi påmeldt tidspunkt (default nå): 2026-03-18 00:00:00
bruker meldt på og ikke på ventelisten
```
 
3. Kjør `registration.py` i python mappen, pass på at brukeren har en booking
```sh
db2/py❯ python registration.py
Oppgi brukernavn (epost): johnny@stud.ntnu.no
Oppgi trening (gruppetimeID): 13
Oppgi oppmøtt tidspunkt (default nå):
Oppmøte registrert.
```

4. Kjør `weeklyschedule.py` i python mappen
```sh
db2/py❯ python weekly_schedule.py
Oppgi år (f.eks. 2026): 2026
Oppgi startdag (f.eks. mandag): tirsdag
Oppgi uke-nummer (f.eks. 12): 12
aktivitet_navn | tidspunkt | senter_navn
Spin 8x3 | 2026-03-17 07:00:00 | Øya treningssenter
Spin60 | 2026-03-17 18:30:00 | Øya treningssenter
Spin 4x4 | 2026-03-17 19:45:00 | Øya treningssenter
Spin60 | 2026-03-18 16:15:00 | Øya treningssenter
Spin45 | 2026-03-18 16:30:00 | Dragvoll
Spin 4x4 | 2026-03-18 17:30:00 | Øya treningssenter
Spin45 | 2026-03-18 18:30:00 | Øya treningssenter
Spin 8x3 | 2026-03-18 19:30:00 | Øya treningssenter
```

5. Kjør `history-johnnny.sql` i sql mappen
```sh
db2/sql❯ sqlite3 databasefil.db < history-johnny.sql
2026-03-16 07:00:00|Øya treningssenter|Spin 4x4
2026-03-16 16:30:00|Dragvoll|Spin 4x4
2026-03-18 19:30:00|Øya treningssenter|Spin 8x3
```

6. Dette skjer automatisk med triggers, se `triggers.sql`

7. Kjør `mvp.py` i python mappen
```sh
db2/py❯ python mvp.py
Oppgi år: 2026
Oppgi måned (01-12): 03
MVP for 2026-03:
- Siri Moe Lund: 3 gruppetimer
```

8. Kjør `train_together.sql` i sql mappen
```sh
db2/sql❯ sqlite3 databasefil.db < train-together.sql
eirin.hansen@sit.no|johnny@stud.ntnu.no|1
eirin.hansen@sit.no|jorunn.berg.bakke@sit.no|1
eirin.hansen@sit.no|siri.moe.lund@sit.no|2
johnny@stud.ntnu.no|jorunn.berg.bakke@sit.no|1
johnny@stud.ntnu.no|siri.moe.lund@sit.no|1
jorunn.berg.bakke@sit.no|siri.moe.lund@sit.no|2
```
