import sqlite3;

con = sqlite3.connect("../sql/test.db")
cursor = con.cursor()

def sjekk_om_påmeldt(data):
    query = "SELECT 1" \
            "FROM Gruppetime INNER JOIN Booking on Gruppetime.id = Booking.gruppetimeID " \
            "WHERE Gruppetime.aktivitet_navn = :aktivitet AND Gruppetime.tidspunkt = :tidspunkt AND Booking.brukerID = :brukerID" 
    cursor.execute(query, data)

    if not cursor.fetchone(): #Ikke påmeldt, bra!
        return False
    return True

def meld_på(data):
    query = "INSERT INTO Booking (gruppetimeID, brukerID) VALUE (:gruppetimeID, :brukerID)"
    cursor.execute(query, data)
    print("meldt på")

data = {
    "aktivitet": input("Oppgi aktivitet: "),
    "epost":  input("Oppgi epost: "),
    "tidspunkt":  input("Oppgi tid: "),
    "STED": input("Oppgi sal (default øya): ").strip() or "Øya",
    "SAL": input("Oppgi sal (default sykkelsal): ").strip() or "Sykkelsal",
}

#finnes aktiviteten?
query = "SELECT gruppetimeID FROM Gruppetime WHERE aktivitet_navn = :aktivitet AND tidspunkt = :tidspunkt AND senter_navn = :STED AND sal_navn = :SAL"
cursor.execute(query, data)
gruppetimeID = cursor.fetchone()

# finnes brukeren?
query = "SELECT brukerID from Bruker WHERE Bruker.epost = :epost"
cursor.execute(query, data)
brukerID = cursor.fetchone()

if gruppetimeID: # aktiviteten finnes
    data["gruppetimeID"] = gruppetimeID
    if brukerID:
        data["brukerID"] = brukerID
        meld_på(data)
    else:
        print("Bruker finne ikke...")
else:
    print("Aktuell time finnes ikke...")
