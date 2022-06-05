.mode tabs
.import '|tail -n +2 /tmp/cleaned.txt' people_import

INSERT INTO people
SELECT
    CAST(substr(nconst, 3, length(nconst)) as int),
    primaryName,
    birthYear,
    deathYear,
    primaryProfession,
    knownForTitles
FROM people_import;
