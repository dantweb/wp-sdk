#!/bin/bash

docker-compose exec db mysql -u${DB_USER} -p${DB_PASSWORD} -e "DROP DATABASE ${DB_NAME}; CREATE DATABASE ${DB_NAME};"
