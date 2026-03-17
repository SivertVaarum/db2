import sqlite3

QUERY = """
WITH input AS (
    SELECT
        date(:startdag) AS startdag,
        :uke AS uke
),
periode AS (
    SELECT
        date(startdag, ((uke - 1) * 7) || ' days') AS fra_dato,
        date(startdag, ((uke * 7) - 1) || ' days') AS til_dato
    FROM input
)
SELECT
    aktivitet_navn, tidspunkt, senter_navn
FROM
    Gruppetime JOIN periode
WHERE
    tidspunkt >= fra_dato AND tidspunkt < date(til_dato, '+1 day')
ORDER BY
    tidspunkt
"""


def hent_ukeplan(
    startdag: str, uke: int, dbnavn: str = "sql/test.db"
) -> tuple[list[str], list[tuple]]:
    params = {
        "startdag": startdag,
        "uke": uke,
    }

    con = sqlite3.connect(dbnavn)
    cursor = con.cursor()
    cursor.execute(QUERY, params)
    rader = cursor.fetchall()
    kolonner = [beskrivelse[0] for beskrivelse in cursor.description or []]
    con.close()
    return kolonner, rader


if __name__ == "__main__":
    startdag = input("Oppgi startdag (YYYY-MM-DD): ").strip()
    uke = int(input("Oppgi uke-nummer (f.eks. 12): ").strip())

    kolonner, rader = hent_ukeplan(startdag=startdag, uke=uke)

    if not rader:
        print("Ingen treninger funnet i valgt uke.")
    else:
        print(" | ".join(kolonner))
        for rad in rader:
            print(" | ".join(str(verdi) for verdi in rad))
