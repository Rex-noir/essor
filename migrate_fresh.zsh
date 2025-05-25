#!/usr/bin/env zsh

set -euo pipefail

echo "Dropping and recreating database $DB_NAME..."

PGPASSWORD="$DB_PASS" psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -c "DROP DATABASE IF EXISTS $DB_NAME;"
PGPASSWORD="$DB_PASS" psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -c "CREATE DATABASE $DB_NAME;"

echo "Running tern migration ... "

tern migrate

echo "✅ Fresh migration completed."
