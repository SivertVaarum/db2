import sqlite3;

dbnavn = "test"
data = {
    "aktivitet": input("Oppgi aktivitet: "),
    "brukernavn":  input("Oppgi brukernavn: "),
    "tidspunkt":  input("Oppgi tid: "),
    "STED": "Øya"
}
con = sqlite3.connect(dbnavn)
cursor = con.cursor()

query = "SELECT 1 FROM Gruppetime WHERE aktivitet_navn = :aktivitet AND tidspunkt = :tidspunkt AND senter_navn = :STED "
cursor.execute(query)

if cursor.fetchone():
    sjekk_om_påmeldt(data)
    meld_på(data)
else:
    print("Aktuell time finnes ikke...")

def sjekk_om_påmeldt():

def meld_på(data):
    query = ""