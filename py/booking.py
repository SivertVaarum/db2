import sqlite3

con = sqlite3.connect("../sql/databasefil.db")
con.execute("PRAGMA foreign_keys = ON") # foreign keys må være på
cursor = con.cursor()

def sjekk_om_avmeldt(data):

    query = """
    SELECT avmeldt_tidspunkt 
    FROM Booking 
    WHERE brukerID = :brukerID AND gruppetimeID = :gruppetimeID
    """

    cursor.execute(query, data)

    return cursor.fetchone()

def meld_på(data):

    rad = sjekk_om_avmeldt(data)

    if rad is None:
        # ingen booking eksisterer
        if data["påmeldt"] is None:
            query = """
            INSERT INTO Booking (gruppetimeID, brukerID)
            VALUES (:gruppetimeID, :brukerID)
            """
        else:
            query = """
            INSERT INTO Booking (gruppetimeID, brukerID, påmeldt_tidspunkt)
            VALUES (:gruppetimeID, :brukerID, :påmeldt)
            """

    elif rad[0] is not None:
        param = "CURRENT_TIMESTAMP" if data["påmeldt"] is None else ":påmeldt"
        # booking eksisterer men avmeldt
        query = f"""
        UPDATE Booking
        SET avmeldt_tidspunkt = NULL, påmeldt_tidspunkt = {param}
        WHERE brukerID = :brukerID
        AND gruppetimeID = :gruppetimeID
        """
    else:
        print("Bruker er allerede meldt på")
        return

    try:
        cursor.execute(query, data)
        con.commit()
    except sqlite3.IntegrityError as e:
        print(e)
        con.rollback()
        return

    print_resultat(data)


def print_resultat(data):
    query = """
    SELECT 1
    FROM GruppetimeDeltakere
    WHERE gruppetimeID = :gruppetimeID
    AND brukerID = :brukerID
    """

    cursor.execute(query, data)

    if cursor.fetchone():
        print("bruker meldt på og ikke på ventelisten")
    else:
        print("bruker meldt på ventelisten")


data = {
    "aktivitet": input("Oppgi aktivitet: ").strip(),
    "epost":  input("Oppgi epost: ").strip(),
    "tidspunkt":  input("Oppgi tid: ").strip(),
    "påmeldt": input("Oppgi påmeldt tidspunkt (default nå): ").strip() or None,
    "STED": input("Oppgi senter (default øya): ").strip() or "Øya treningssenter",
    "SAL": input("Oppgi sal (default sykkelsal): ").strip() or "Sykkelsal",
}

#finnes aktiviteten?
query = """
SELECT id 
FROM Gruppetime 
WHERE aktivitet_navn = :aktivitet 
AND tidspunkt = :tidspunkt 
AND senter_navn = :STED 
AND sal_navn = :SAL
"""

cursor.execute(query, data)
gruppetimeID = cursor.fetchone()

# finnes brukeren?
query = "SELECT id from Bruker WHERE Bruker.epost = :epost"
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
