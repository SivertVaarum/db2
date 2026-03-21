from py import helper


def hent_mvp(år: int, month: str):

    (con, cursor) = helper.openConnection()

    QUERY = helper.readQuery("mvp.sql")
    cursor.execute(QUERY, {"month": f"{år}-{month}"})

    rader = cursor.fetchall()
    con.close()

    return rader

if __name__ == "__main__":
    år = int(input("Oppgi år: ").strip())
    month = str(input("Oppgi måned (01-12): ").strip())

    rader = hent_mvp(år=år, month=month)

    if not rader:
        print("Ingen deltakelser funnet i valgt måned")
    else:
        print(f"MVP for {år}-{month}:")
        for navn, antall in rader:
            print(f"- {navn}: {antall} gruppetimer")
