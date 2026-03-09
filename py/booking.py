import sqlite3;

con = sqlite3.connect(dbnavn)
cursor = con.cursor()

def sjekk_om_påmeldt(data):
    query = "SELECT *" \
            "FROM Gruppetime INNER JOIN Booking on Gruppetime.id = Booking.gruppetimeID INNER JOIN bruker on bruker.id = Booking.brukerID " \
            "WHERE Gruppetime.aktivitet_navn = :aktivitet AND Gruppetime.tidspunkt = :tidspunkt AND bruker.epost = :epost " 
    cursor.execute(query, data)
    if not cursor.fetchone(): #Ikke påmeldt, bra!
        return False
    return True
def meld_på(data):
    query = "INSERT INTO Booking (epost, aktivite_)VALUE"

dbnavn = "test"
data = {
    "aktivitet": input("Oppgi aktivitet: "),
    "epost":  input("Oppgi epost: "),
    "tidspunkt":  input("Oppgi tid: "),
    "STED": "Øya"
}

query = "SELECT 1 FROM Gruppetime WHERE aktivitet_navn = :aktivitet AND tidspunkt = :tidspunkt AND senter_navn = :STED "
cursor.execute(query, data)

if cursor.fetchone(): #finnes aktiviteten?
    if not sjekk_om_påmeldt(data):  #er person allerede påmeldt?
        meld_på(data)
    else:
        print("allerede påmeldt...")
else:
    print("Aktuell time finnes ikke...")
