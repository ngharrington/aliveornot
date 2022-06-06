.mode tabs
.import /tmp/cleaned.txt people_import

INSERT INTO people
SELECT
    CAST(substr(nconst, 3, length(nconst)) as int),
    primaryName,
    birthYear,
    deathYear,
    primaryProfession,
    knownForTitles
FROM people_import;


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
