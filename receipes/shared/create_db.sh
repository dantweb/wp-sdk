#!/bin/bash

DB_NAME=${1:-wordpress}

if [ -z "$DB_NAME" ]; then
  echo "Database name not provided, defaulting to 'wordpress'"
fi

docker-compose exec db mysql -u${DB_USER} -p${DB_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
