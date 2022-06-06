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

-- Clean up the null characters and make them true nulls
UPDATE people
SET primaryName=NULL
WHERE primaryName='\N'
;

UPDATE people
SET birthyear=NULL
WHERE birthyear='\N'
;

UPDATE people
SET deathyear=NULL
WHERE deathyear='\N'
;

UPDATE people
SET primaryProfession=NULL
WHERE primaryProfession='\N'
;

UPDATE people
SET knownForTitles=NULL
WHERE knownForTitles='\N'
;
