#!/bin/bash

set -e

function usage()
{
    echo -e "Clean up imdb tsv and import it into sqlite"
    echo -e ""
    echo -e "./pipeline.sh"
    echo -e "\t-h --help"
    echo -e "\t--db_file=$DB_FILE"
    echo ""
}


SQLITE_BINARY=/usr/bin/sqlite3
DIRNAME=$(dirname -- "$0")

SOURCE_PEOPLE_FILE=/tmp/people.txt
INTERMEDIATE_PEOPLE_FILE=/tmp/people_cleaned.txt

SOURCE_TITLE_FILE=/tmp/title.txt
INTERMEDIATE_TITLE_FILE=/tmp/title_cleaned.txt

SOURCE_PRINCIPALS_FILE=/tmp/principals.txt
INTERMEDIATE_PRINCIPALS_FILE=/tmp/principals_cleaned.txt

SOURCE_RATINGS_FILE=/tmp/ratings.txt
INTERMEDIATE_RATINGS_FILE=/tmp/ratings_cleaned.txt



while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --db_file)
            DB_FILE=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [ -z ${DB_FILE+x} ]; then echo "--db_file is unset, failing"; exit 1; fi

echo "Downloading the imdb datset at https://datasets.imdbws.com/name.basics.tsv.gz..."
wget -q -O $SOURCE_PEOPLE_FILE.gz https://datasets.imdbws.com/name.basics.tsv.gz

echo "Downloading the imdb datset at https://datasets.imdbws.com/title.basics.tsv.gz..."
wget -q -O $SOURCE_TITLE_FILE.gz https://datasets.imdbws.com/title.basics.tsv.gz

echo "Downloading the imdb datset at https://datasets.imdbws.com/title.principals.tsv.gz..."
wget -q -O $SOURCE_PRINCIPALS_FILE.gz https://datasets.imdbws.com/title.principals.tsv.gz

echo "Downloading the imdb datset at https://datasets.imdbws.com/title.ratings.tsv.gz..."
wget -q -O $SOURCE_RATINGS_FILE.gz https://datasets.imdbws.com/title.ratings.tsv.gz

echo "Extracting the gzipped files.."
gzip -d $SOURCE_PEOPLE_FILE.gz
gzip -d $SOURCE_TITLE_FILE.gz
gzip -d $SOURCE_PRINCIPALS_FILE.gz
gzip -d $SOURCE_RATINGS_FILE.gz

echo "creating properly quoted tsv people..."
sed 's/"/""/g;s/[^\t]*/"&"/g' $SOURCE_PEOPLE_FILE  >$INTERMEDIATE_PEOPLE_FILE

echo "creating properly quoted tsv titles..."
sed 's/"/""/g;s/[^\t]*/"&"/g' $SOURCE_TITLE_FILE  >$INTERMEDIATE_TITLE_FILE

echo "creating properly quoted tsv principals..."
sed 's/"/""/g;s/[^\t]*/"&"/g' $SOURCE_PRINCIPALS_FILE  >$INTERMEDIATE_PRINCIPALS_FILE

echo "creating sqlite3 db..."
rm -f $DB_FILE
$SQLITE_BINARY $DB_FILE "VACUUM;"

echo "creating sqlite3 table..."
$SQLITE_BINARY $DB_FILE < $DIRNAME/ddl.sql

echo "importing to sqlite..."
$SQLITE_BINARY $DB_FILE < $DIRNAME/import.sql

echo "import complete"

echo "cleaning up intermediate file..."
rm -f $INTERMEDIATE_PEOPLE_FILE
rm -f $SOURCE_PEOPLE_FILE

rm -f $INTERMEDIATE_TITLE_FILE
rm -f $SOURCE_TITLE_FILE

rm -f $INTERMEDIATE_PRINCIPALS_FILE
rm -f $SOURCE_PRINCIPALS_FILE

rm -f $SOURCE_RATINGS_FILE
