#!/bin/bash

set -e

DB_USER="${DB_USER:-postgres}"
DB_PORT="${DB_PORT:-5432}"

function usage() {
  echo "Usage: ./backup.sh"
  echo ""
  echo "Requires the following environment variables to be set:"
  echo "  DB_HOST - The hostname or IP address of the database host"
  echo "  DB_PORT - The port the database can be found on the database host (defaults to 5432)"
  echo "  DB_NAME - The name of the database to back up"
  echo "  DB_USER - The user to take the backup with (defaults to postgres)"
  echo "  DB_PASSWORD - The password to authenticate the user"
  echo "  S3_HOST - The hostname of the S3 server (ie ams3.digtialoceanspaces.com)"
  echo "  BUCKET_NAME - The bucket to store the backup in."
  echo "  ACCESS_KEY - The S3 access key."
  echo "  SECRET_KEY - The S3 secret key."
  echo ""
}

function validate_variable() {
  VAR_NAME=$1
  if [ -z "${!VAR_NAME}" ]; then
    echo "Environment $VAR_NAME is not set."
    usage
    exit 1
  fi
}

validate_variable "DB_HOST"
validate_variable "DB_PORT"
validate_variable "DB_NAME"
validate_variable "DB_USER"
validate_variable "DB_PASSWORD"
validate_variable "S3_HOST"
validate_variable "BUCKET_NAME"
validate_variable "ACCESS_KEY"
validate_variable "SECRET_KEY"

echo "Running $DB_NAME backup"

mkdir /tmp/backup
BACKUP_NAME=/tmp/backup/${DB_NAME}-$(date +\%F).sql
export PGPASSWORD=$DB_PASSWORD
pg_dump -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" > $BACKUP_NAME
s3cmd put $BACKUP_NAME s3://$BUCKET_NAME/ \
  --host=$S3_HOST \
  --access_key=$ACCESS_KEY \
  --secret_key=$SECRET_KEY
echo "Backup complete."