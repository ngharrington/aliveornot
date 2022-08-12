.mode tabs
.import /tmp/people_cleaned.txt people_import
.import /tmp/title_cleaned.txt title_import
.import /tmp/principals_cleaned.txt principal_import
.import /tmp/ratings.txt rating

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

DROP TABLE people_import;


INSERT INTO title
SELECT
    CAST(substr(tconst, 3, length(tconst)) as int) tconst,
    titleType,
    primaryTitle,
    originalTitle,
    CAST(isAdult as INT),
    CAST(startYear as INT),
    CAST(endYear as INT),
    CAST(runtimeMinutes as INT),
    genres
FROM title_import;


-- -- Clean up the null characters and make them true nulls
UPDATE title
SET titleType=NULL
WHERE titleType='\N'
;

UPDATE title
SET primaryTitle=NULL
WHERE primaryTitle='\N'
;

UPDATE title
SET originalTitle=NULL
WHERE originalTitle='\N'
;

UPDATE title
SET isAdult=NULL
WHERE isAdult='\N'
;

UPDATE title
SET startYear=NULL
WHERE startYear='\N'
;

UPDATE title
SET endYear=NULL
WHERE endYear='\N'
;

UPDATE title
SET runtimeMinutes=NULL
WHERE runtimeMinutes='\N'
;

DROP TABLE title_import;

INSERT INTO principal
SELECT
    CAST(substr(tconst, 3, length(tconst)) as int) tconst,
    CAST(ordering as INT),
    CAST(substr(nconst, 3, length(nconst)) as int),
    category,
    job,
    characters
FROM principal_import;

UPDATE principal
SET ordering=NULL
WHERE ordering='\N';

UPDATE principal
SET category=NULL
WHERE category='\N';

UPDATE principal
SET job=NULL
WHERE job='\N';

UPDATE principal
SET characters=NULL
WHERE characters='\N';

DROP TABLE principal_import;

UPDATE rating
SET tconst=CAST(substr(tconst, 3, length(tconst)) as int);

-- reclaim freed space.
VACUUM;


-- construct the primary data set
create table alive as
select
	c.nconst,
	c.primaryName,
	CASE WHEN c.deathYear IS NULL THEN 1 ELSE 0 END alive,
	sum(numVotes) totalVotes
from principal a
inner join title b on a.tconst=b.tconst
inner join people c on a.nconst = c.nconst
inner join rating d on b.tconst = d.tconst
group by 
	c.nconst, 
	c.primaryName
order by 
	sum(numVotes) desc;

DROP TABLE principal;
DROP TABLE rating;
DROP TABLE people;
DROP TABLE title;

VACUUM;