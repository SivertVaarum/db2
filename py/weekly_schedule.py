from datetime import date
from py import helper

UKEDAGER = {
    "mandag": 1,
    "tirsdag": 2,
    "onsdag": 3,
    "torsdag": 4,
    "fredag": 5,
    "lørdag": 6,
    "søndag": 7,
}

def hent_ukeplan(år: int, uke: int, startdag: str):
    startdato = date.fromisocalendar(år, uke, UKEDAGER[startdag.lower()]).isoformat()
    QUERY = helper.readQuery("weekly_schedule.sql")
    (con, cursor) = helper.openConnection()

    cursor.execute(QUERY, {"startdato": startdato})
    rader = cursor.fetchall()
    kolonner = [beskrivelse[0] for beskrivelse in cursor.description or []]
    con.close()

    return kolonner, rader


if __name__ == "__main__":
    år = int(input("Oppgi år (f.eks. 2026): ").strip())
    startdag = input("Oppgi startdag (f.eks. mandag): ").strip()
    uke = int(input("Oppgi uke-nummer (f.eks. 12): ").strip())

    kolonner, rader = hent_ukeplan(år = år, startdag=startdag, uke=uke)

    if not rader:
        print("Ingen treninger funnet i valgt uke.")
    else:
        print(" | ".join(kolonner))
        for rad in rader:
            print(" | ".join(str(verdi) for verdi in rad))
