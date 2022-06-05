#!/bin/bash

set -e

function usage()
{
    echo -e "Clean up imdb tsv and import it into sqlite"
    echo -e ""
    echo -e "./pipeline.sh"
    echo -e "\t-h --help"
    echo -e "\t--db_file=$DB_FILE"
    echo -e "\t--db_table=$DB_TABLE"
    echo ""
}

SQLITE_BINARY=/usr/bin/sqlite3
INTERMEDIATE_FILE=/tmp/cleaned.txt


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
        --db_table)
            DB_TABLE=$VALUE
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
if [ -z ${DB_TABLE+x} ]; then echo "--db_table is unset, failing"; exit 1; fi


SOURCE_FILE=/tmp/data.txt

echo "Downloading the imdb datset at https://datasets.imdbws.com/name.basics.tsv.gz..."
wget -q -O $SOURCE_FILE.gz https://datasets.imdbws.com/name.basics.tsv.gz

echo "Extracting the gzipped files.."
gzip -d /tmp/data.txt.gz

echo "creating properly quoted tsv..."
sed 's/"/""/g;s/[^\t]*/"&"/g' $SOURCE_FILE  >$INTERMEDIATE_FILE

echo "creating sqlite3 db..."
rm -f $DB_FILE
$SQLITE_BINARY $DB_FILE "VACUUM;"

echo "creating sqlite3 target table 'people'..."
$SQLITE_BINARY $DB_FILE < people.sql

echo "importing to sqlite..."
$SQLITE_BINARY $DB_FILE < import.sql

echo "import complete"

echo "cleaning up intermediate file..."
rm -f $INTERMEDIATE_FILE
rm -f $SOURCE_FILE