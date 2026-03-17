import sqlite3


def registrer_oppmote(data, dbnavn="sql/test.db"):
    con = sqlite3.connect(dbnavn)
    cursor = con.cursor()

    query = """
    INSERT INTO Deltatt (gruppetimeID, brukerID)
    SELECT b.gruppetimeID, b.brukerID
    FROM Booking b
    JOIN Bruker u ON u.id = b.brukerID
    WHERE u.epost = :brukernavn
      AND b.gruppetimeID = :trening_id
      AND b.avmeldt_tidspunkt IS NULL
    """

    cursor.execute(query, data)
    con.commit()

    if cursor.rowcount == 0:
        print("Fant ingen aktiv booking som kan registreres.")
    else:
        print("Oppmøte registrert.")

    con.close()


if __name__ == "__main__":
    data = {
        "brukernavn": input("Oppgi brukernavn (epost): "),
        "trening_id": int(input("Oppgi trening (gruppetimeID): ")),
    }
    registrer_oppmote(data)
