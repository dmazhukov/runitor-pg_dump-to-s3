#!/bin/bash

set -e -u

if [ -z "$DB_HOST" ]; then
  echo "Environment DB_HOST is not set - it should be the host running the carolsrecipes DB"
  exit 1
fi

if [ -z "$DB_PORT" ]; then
  echo "Environment DB_PORT is not set - it should be the port of the carolsrecipes DB"
  exit 1
fi

echo "Running carolsrecipes backup"

mkdir /tmp/backup
BACKUP_NAME=/tmp/backup/recipes-$(date +\%F).sql
export PGPASSWORD=postgres
pg_dump -U postgres -h "$DB_HOST" -p "$DB_PORT" -d carols_recipes > $BACKUP_NAME
s3cmd put $BACKUP_NAME s3://carolsrecipesbackups/ \
  --host=ams3.digitaloceanspaces.com \
  --access_key=$DO_SPACE_ACCESS_KEY \
  --secret_key=$DO_SPACE_SECRET_KEY
echo "Backup complete."