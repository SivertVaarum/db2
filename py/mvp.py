import sqlite3

with open("sql/mvp.sql", "r", encoding="utf-8") as fil:
    QUERY = fil.read()

def hent_mvp(år: int, month: int, dbnavn="sql/test.db"):
    måned_start = f'{år:04d}-{month:02d}-01'

    con = sqlite3.connect(dbnavn)
    cursor = con.cursor()
    cursor.execute(QUERY, {"month": måned_start})
    rader = cursor.fetchall()
    kolonner = [beskrivelse[0] for beskrivelse in cursor.description or []]
    con.close()
    return kolonner, rader

if __name__ == "__main__":
    år = int(input("Oppgi år: ").strip())
    month = int(input("Oppgi måned (1-12): ").strip())

    kolonner, rader = hent_mvp(år=år, month=month)

    if not rader:
        print("Ingen deltakelser funnet i valgt måned")
    else:
        print(f"MVP for {år}-{month}:")
        for navn, antall in rader:
            print(f"- {navn}: {antall} gruppetimer")