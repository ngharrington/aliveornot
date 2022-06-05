from fastapi import FastAPI
from pydantic import BaseModel
import sqlite3
import os

SQLITE_DB = os.environ.get("ALIVE_OR_NOT_SQLITE_DB")


class AliveSchema(BaseModel):
    is_alive: bool

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/alive/{id}")
async def alive(id: int):
    """Given an ID for a person, return whether they are alive or not (tm)"""
    
    

