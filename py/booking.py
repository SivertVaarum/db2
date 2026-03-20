import sqlite3

con = sqlite3.connect("../sql/databasefil.db")
con.execute("PRAGMA foreign_keys = ON") # foreign keys må være på
cursor = con.cursor()

def sjekk_om_påmeldt(data):

    query = """
    SELECT 1 
    FROM Gruppetime INNER JOIN Booking on Gruppetime.id = Booking.gruppetimeID 
    WHERE Gruppetime.aktivitet_navn = :aktivitet AND Gruppetime.tidspunkt = :tidspunkt AND Booking.brukerID = :brukerID
    """

    cursor.execute(query, data)

    if not cursor.fetchone(): #Ikke påmeldt, bra!
        return False
    return True

def meld_på(data):

    if not data["påmeldt"]:
        query = """
        INSERT INTO Booking (gruppetimeID, brukerID)
        VALUES (:gruppetimeID, :brukerID)
        """
    else:
        query = """
        INSERT INTO Booking (gruppetimeID, brukerID, påmeldt_tidspunkt)
        VALUES (:gruppetimeID, :brukerID, :påmeldt)
        """

    try:
        cursor.execute(query, data)
        con.commit()
        print("meldt på")
    except sqlite3.IntegrityError as e:
        print(e)

data = {
    "aktivitet": input("Oppgi aktivitet: ").strip(),
    "epost":  input("Oppgi epost: ").strip(),
    "tidspunkt":  input("Oppgi tid: ").strip(),
    "påmeldt": input("Oppgi påmeldt tidspunkt (default nå): ").strip(),
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
        print("Bruker finne ikke...")
else:
    print("Aktuell time finnes ikke...")

con.close()
