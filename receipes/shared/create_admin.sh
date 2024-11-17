#!/bin/bash

ADMIN_USER=${1:-admin}
ADMIN_PASS=${2:-admin}

if [ -z "$ADMIN_USER" ]; then
  echo "Admin username not provided, defaulting to 'admin'"
fi

if [ -z "$ADMIN_PASS" ]; then
  echo "Admin password not provided, defaulting to 'admin'"
fi

docker-compose exec web wp user create "$ADMIN_USER" "${ADMIN_USER}@example.com" --role=administrator --user_pass="$ADMIN_PASS"
