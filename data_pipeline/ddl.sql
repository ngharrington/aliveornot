CREATE TABLE people_import (
    nconst TEXT NOT NULL,
    primaryName TEXT,
    birthYear INT,
    deathYear INT,
    primaryProfession TEXT,
    knownForTitles TEXT
);


CREATE TABLE people (
    nconst INT,
    primaryName TEXT,
    birthYear INT,
    deathYear INT,
    primaryProfession TEXT,
    knownForTitles TEXT
);


CREATE TABLE title_import (
    tconst TEXT NOT NULL,
    titleType TEXT,
    primaryTitle TEXT,
    originalTitle TEXT,
    isAdult TEXT,
    startYear TEXT,
    endYear TEXT,
    runtimeMinutes TEXT,
    genres TEXT
);


CREATE TABLE title (
    tconst INT NOT NULL,
    titleType TEXT,
    primaryTitle TEXT,
    originalTitle TEXT,
    isAdult INT,
    startYear INT,
    endYear INT,
    runtimeMinutes INT,
    genres TEXT
);

CREATE TABLE principal_import (
    tconst TEXT,
    ordering TEXT,
    nconst TEXT,
    category TEXT,
    job TEXT,
    characters TEXT
);

CREATE TABLE principal (
    tconst INT,
    ordering INT,
    nconst INT,
    category TEXT,
    job TEXT,
    characters TEXT
);

CREATE TABLE rating (
    tconst int,
    averageRating int,
    numVotes int
)