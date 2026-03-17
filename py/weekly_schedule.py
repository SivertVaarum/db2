import sqlite3
from datetime import date

UKEDAGER = {
    "mandag": 1,
    "tirsdag": 2,
    "onsdag": 3,
    "torsdag": 4,
    "fredag": 5,
    "lørdag": 6,
    "søndag": 7,
}

QUERY = """
    SELECT aktivitet_navn, tidspunkt, senter_navn
    FROM Gruppetime
    WHERE tidspunkt >= :startdato
        AND tidspunkt < date(:startdato, '+7 days')
    ORDER BY tidspunkt;
"""


def hent_ukeplan(år: int, uke: int, startdag: str, dbnavn: str = "sql/test.db"):
    startdato = date.fromisocalendar(år, uke, UKEDAGER[startdag.lower()]).isoformat()


    con = sqlite3.connect(dbnavn)
    cursor = con.cursor()
    cursor.execute(QUERY, {"startdato": startdato})
    rader = cursor.fetchall()
    kolonner = [beskrivelse[0] for beskrivelse in cursor.description or []]
    con.close()
    return kolonner, rader


if __name__ == "__main__":
    år = int(input("Oppgi år: ").strip())
    startdag = input("Oppgi startdag (f.eks. mandag): ").strip()
    uke = int(input("Oppgi uke-nummer (f.eks. 12): ").strip())

    kolonner, rader = hent_ukeplan(år = år, startdag=startdag, uke=uke)

    if not rader:
        print("Ingen treninger funnet i valgt uke.")
    else:
        print(" | ".join(kolonner))
        for rad in rader:
            print(" | ".join(str(verdi) for verdi in rad))
