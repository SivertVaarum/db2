import sqlite3
import helper

(con, cursor) = helper.openConnection()

def sjekk_om_avmeldt(data):
    query = helper.readQuery("er-avmeldt.sql")
    cursor.execute(query, data)
    return cursor.fetchone()

def meld_på(data):

    rad = sjekk_om_avmeldt(data)
    booking_eksisterer = rad is not None
    avmeldt = booking_eksisterer and rad[0] is not None
    påmeldt_arg = data["påmeldt"] is not None

    if booking_eksisterer and not avmeldt:
        print("Bruker er allerede meldt på")
        return

    file = "update" if booking_eksisterer else "insert"
    file += "-booking-"
    file += "pameldt" if påmeldt_arg else "default"
    file += ".sql"

    query = helper.readQuery(file)

    try:
        cursor.execute(query, data)
        con.commit()
    except sqlite3.IntegrityError as e:
        con.rollback()
        print(e)
        return

    print_resultat(data)


def print_resultat(data):
    query = helper.readQuery("er-pameldt.sql")

    cursor.execute(query, data)

    if cursor.fetchone():
        print("bruker meldt på og ikke på ventelisten")
    else:
        print("bruker meldt på ventelisten")


data = {
    "epost":  input("Oppgi epost: ").strip(),
    "aktivitet": input("Oppgi aktivitet: ").strip(),
    "tidspunkt":  input("Oppgi tid: ").strip(),
    "STED": input("Oppgi senter (default øya): ").strip() or "Øya treningssenter",
    "SAL": input("Oppgi sal (default sykkelsal): ").strip() or "Sykkelsal",
    "påmeldt": input("Oppgi påmeldt tidspunkt (default nå): ").strip() or None,
}

#finnes aktiviteten?
query = helper.readQuery("get-gruppetime.sql")

cursor.execute(query, data)
gruppetimeID = cursor.fetchone()

# finnes brukeren?
query = helper.readQuery("get-bruker-epost.sql")
cursor.execute(query, data)
brukerID = cursor.fetchone()

if gruppetimeID: # aktiviteten finnes
    data["gruppetimeID"] = gruppetimeID[0]
    if brukerID:
        data["brukerID"] = brukerID[0]
        meld_på(data)
    else:
        print("Bruker finnes ikke...")
else:
    print("Aktuell time finnes ikke...")

con.close()
