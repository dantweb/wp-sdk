#!/bin/bash

FORCE_DOWNLOAD=no
FORCE_INSTALL=no

# Load environment variables from .env
set -a
source .env
set +a

# Parse command line arguments
for arg in "$@"
do
  case $arg in
    --force-download=yes)
      FORCE_DOWNLOAD=yes
      shift
      ;;
    --force-install=yes)
      FORCE_INSTALL=yes
      shift
      ;;
  esac
done

# Check if WordPress files are already present
if docker-compose exec web [ -f /var/www/html/wp-load.php ]; then
  if [ "$FORCE_DOWNLOAD" == "yes" ]; then
    echo "Forcing WordPress core download..."
    docker-compose exec web wp core download --locale=en_US --force
  else
    echo "Skipping WordPress download as force-download is set to 'no'."
  fi
else
  echo "Downloading WordPress core files..."
  docker-compose exec web wp core download --locale=en_US
fi

# Check if wp-config.php exists, if not create it
echo "Checking for wp-config.php..."
if ! docker-compose exec web [ -f /var/www/html/wp-config.php ]; then
  echo "wp-config.php not found, creating it..."
  docker-compose exec web wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --skip-check
fi

# Wait for MySQL to be ready before proceeding
max_attempts=10
attempts=0
until docker-compose exec db mysqladmin ping -h "$DB_HOST" --silent; do
  attempts=$((attempts + 1))
  if [ $attempts -ge $max_attempts ]; then
    echo "MySQL is not ready after $max_attempts attempts, exiting."
    exit 1
  fi
  echo "Waiting for MySQL to be ready... (attempt $attempts)"
  sleep 5
done

# Check if WordPress is already installed
if docker-compose exec web wp core is-installed; then
  if [ "$FORCE_INSTALL" == "yes" ]; then
    echo "Forcing WordPress installation..."
    ./receipes/wordpress/reset_db.sh
    docker-compose exec web wp core install \
      --url="$WORDPRESS_URL" \
      --title="$WORDPRESS_SITE_NAME" \
      --admin_user="$ADMIN_USER" \
      --admin_password="$ADMIN_PASSWORD" \
      --admin_email="$ADMIN_EMAIL"
  else
    echo "Skipping WordPress installation as force-install is set to 'no'."
  fi
else
  echo "Installing WordPress..."
  docker-compose exec web wp core install \
    --url="$WORDPRESS_URL" \
    --title="$WORDPRESS_SITE_NAME" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL"
fi

