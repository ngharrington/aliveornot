from typing import List
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


class AliveSchema(BaseModel):
    id: int
    name: str
    is_alive: bool
    unique_result: bool

app = FastAPI()

@app.get("/api")
async def root():
    return {"message": "Hello World"}

@app.get("/api/people/{id}")
async def get_person(id: int) -> AliveSchema:
    """Given an ID for a person, respond with information about that person"""
    db = get_db_connection()
    cur = db.cursor()
    cur.execute("SELECT nconst, primaryName, alive as is_alive from alive where nconst=?", (id,))
    row = cur.fetchone()
    response = AliveSchema(
        id=row[0],
        name=row[1],
        is_alive=row[2]
    )
    return response
    
@app.get("/api/people")
async def get_person_by_name(search: str) -> List[AliveSchema]:
    """Given an full name for a person, respond with information about that person"""
    db = get_db_connection()
    cur = db.cursor()
    # since this is crude for now we just pick a random result. This must be improved.
    cur.execute("SELECT nconst, primaryName, alive as is_alive from alive where lower(primaryName)=lower(?) order by random()", (search,))
    rows = cur.fetchmany(2)
    try:
        row = rows[0]
    except IndexError:
        return []
    unique_result = len(rows) == 1
    response = [AliveSchema(
        id=row[0],
        name=row[1],
        is_alive=row[2],
        unique_result=unique_result,
    )]
    return response

