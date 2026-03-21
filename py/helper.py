import sqlite3

def openConnection() -> tuple[sqlite3.Connection, sqlite3.Cursor]:
    con = sqlite3.connect("../sql/databasefil.db")
    con.execute("PRAGMA foreign_keys = ON") # foreign keys må være på
    cursor = con.cursor()
    return (con, cursor)


def readQuery(file: str):
    with open(f"../sql/python-helpers/{file}", "r", encoding="utf-8") as fil:
        return fil.read()


