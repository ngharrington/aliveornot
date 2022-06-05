CREATE TABLE people_import (
    nconst TEXT NOT NULL,
    primaryName TEXT,
    birthYear INT,
    deathYear INT,
    primaryProfession TEXT,
    knownForTitles TEXT
);


CREATE TABLE people (
    id INT,
    primaryName TEXT,
    birthYear INT,
    deathYear INT,
    primaryProfession TEXT,
    knownForTitles TEXT
);


DROP TABLE people_import;