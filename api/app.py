from typing import List, Optional
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import sqlite3
import os

SQLITE_DB = os.environ.get("ALIVE_OR_NOT_SQLITE_DB", "/code/db.sqlite")

class DbConnectionError(Exception):
    pass

def get_db_connection():
    conn = None
    try:
        conn = sqlite3.connect(SQLITE_DB)
    except sqlite3.OperationalError:
        raise DbConnectionError(f"Could not open sqlite database at {SQLITE_DB}")
    return conn


class Person(BaseModel):
    id: int
    name: str
    is_alive: Optional[bool]

app = FastAPI()

@app.get("/api")
async def root():
    return {"message": "Hello World"}

@app.get("/api/people")
async def search_by_name(search: str) -> List[Person]:
    """Given an full name for a person, respond with information about that person"""
    db = get_db_connection()
    cur = db.cursor()
    # since this is crude for now we just pick a random result. This must be improved.
    query = """
    SELECT nconst, primaryName
    FROM alive
        WHERE substr(lower(primaryName), 0, length(lower(?))+1)=lower(?)
    ORDER BY totalVotes desc
    """
    cur.execute(query, (search, search))
    rows = cur.fetchmany(5)
    response = []
    for row in rows:
        response.append(
            Person(
                id=row[0],
                name=row[1],
                is_alive=None,)
        )
    return response



@app.get("/api/people/{id}")
async def get_person(id: int) -> Person:
    """Given an ID for a person, respond with information about that person"""
    db = get_db_connection()
    cur = db.cursor()
    cur.execute("SELECT nconst, primaryName, alive as is_alive from alive where nconst=?", (id,))
    row = cur.fetchone()
    response = Person(
        id=row[0],
        name=row[1],
        is_alive=row[2]
    )
    return response
    
