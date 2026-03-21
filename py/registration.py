import sqlite3
from py import helper


def registrer_oppmote(data):
    oppmøtt_arg = data["oppmøtt_tidspunkt"] is not None

    file = "registrer-deltakelse-"
    file += "oppmott" if oppmøtt_arg else "default"
    file += ".sql"
    query = helper.readQuery(file)

    (con, cursor) = helper.openConnection()
    try: 
        cursor.execute(query, data)
        con.commit()
        if cursor.rowcount == 0:
            print("Brukeren finnes ikke.")
        else:
            print("Oppmøte registrert.")
    except sqlite3.IntegrityError as e:
        con.rollback()
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
