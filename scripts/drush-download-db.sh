#!/bin/sh
##
# Download latest DB backup via drush.
#

LOCAL_PATH="/tmp/.data/"
DB_FILE_NAME="db.sql"
LOCAL_DB_PATH=$LOCAL_PATH$DB_FILE_NAME
DUMP_PATH="/tmp/$DB_FILE_NAME"

fetch_db() {
  mkdir -p $LOCAL_PATH
  drush -y rsync @production:$DUMP_PATH $LOCAL_PATH > /dev/null
  echo $?
}

dump_db() {
  drush @production sql-dump --skip-tables-key=common --result-file=$DUMP_PATH > /dev/null
  echo $?
}

if [ ! -f $LOCAL_DB_PATH ]; then
  echo "Fetching production DB dump"
  fetched=$(fetch_db)

  if [ "$fetched" != "0" ]; then
    echo "Creating new production dump"
    dumped=$(dump_db)
    if [ "$dumped" != "0" ]; then
      echo "Unable to dump DB file in production"
      exit 1;
    fi

    fetched=$(fetch_db)
    if [ "$fetched" != "0" ] || [ ! -f $LOCAL_DB_PATH ]; then
      echo "Unable to fetch DB dump"
      exit 1;
    fi
  fi
fi

[ ! -s $LOCAL_DB_PATH ] && rm -r $LOCAL_DB_PATH && "Invalid file size. Please check production DB" && exit 1
