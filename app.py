from fastapi import FastAPI
from pydantic import BaseModel
import sqlite3
import os

SQLITE_DB = os.environ.get("ALIVE_OR_NOT_SQLITE_DB", "db.sqlite")

class DbConnectionError(Exception):
    pass

def get_db_connection():
    conn = None
    try:
        conn = sqlite3.connect(SQLITE_DB)
    except sqlite3.OperationalError:
        raise DbConnectionError(f"Could not open sqlite database at {SQLITE_DB}")
    return conn


class AliveSchema(BaseModel):
    id: int
    name: str
    is_alive: bool

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/people/{id}")
async def get_person(id: int) -> AliveSchema:
    """Given an ID for a person, respond with information about that person"""
    db = get_db_connection()
    cur = db.cursor()
    cur.execute("SELECT id, primaryName, case when deathYear is null then 1 else 0 end as is_alive from people where id=?", (id,))
    row = cur.fetchone()
    response = AliveSchema(
        id=row[0],
        name=row[1],
        is_alive=row[2]
    )
    return response
    
@app.get("/people")
async def get_person_by_name(name: str):
    """Given an full name for a person, respond with information about that person"""
    db = get_db_connection()
    cur = db.cursor()
    cur.execute("SELECT id, primaryName, case when deathYear is null then 1 else 0 end as is_alive from people where lower(primaryName)=lower(?)", (name,))
    rows = cur.fetchmany()
    if len(rows) > 1 or len(rows) == 0:
        raise Exception("Didn't return a unique result.")
    row = rows[0]
    response = AliveSchema(
        id=row[0],
        name=row[1],
        is_alive=row[2]
    )
    return response

