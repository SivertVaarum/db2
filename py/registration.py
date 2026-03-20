import sqlite3

dbnavn = "../sql/databasefil.db"

def registrer_oppmote(data):
    con = sqlite3.connect(dbnavn)
    con.execute("PRAGMA foreign_keys = ON") # foreign keys må være på
    cursor = con.cursor()

    if data["oppmøtt_tidspunkt"]:
        query = """
        INSERT INTO Deltatt (gruppetimeID, brukerID, oppmøtt_tidspunkt)
        SELECT :trening_id, id, :oppmøtt_tidspunkt
        From Bruker
        WHERE epost = :brukernavn
        """
    else:
        query = """
        INSERT INTO Deltatt (gruppetimeID, brukerID)
        SELECT :trening_id, id
        From Bruker
        WHERE epost = :brukernavn
        """

    try: 
        cursor.execute(query, data)
        con.commit()
        if cursor.rowcount == 0:
            print("Brukeren finnes ikke.")
        else:
            print("Oppmøte registrert.")
    except sqlite3.IntegrityError as e:
        print(e)
    finally:
        con.close()


if __name__ == "__main__":
    data = {
        "brukernavn": input("Oppgi brukernavn (epost): ").strip(),
        "trening_id": int(input("Oppgi trening (gruppetimeID): ").strip()),
        "oppmøtt_tidspunkt": input("Oppgi oppmøtt tidspunkt (default nå): ").strip()
    }
    registrer_oppmote(data)
