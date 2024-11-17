# WordPress SDK Setup

This SDK will help you easily set up a WordPress environment using Docker. You can use the default setup to have WordPress running on [http://localhost:8080](http://localhost:8080), or you can configure the environment using the `.env` file before installing WordPress.

## Prerequisites
- Docker
- Docker Compose

## Getting Started

### 1. Clone the Repository
Clone the repository that contains the Docker Compose and WordPress setup files.
```bash
$ git clone <repository-url>
$ cd <repository-folder>
```

### 2. Configure Environment Variables (Optional)
You can edit the `.env.dist` file to customize the environment variables for your WordPress installation.
Rename `.env.dist` to `.env` after editing:
```bash
$ cp .env.dist .env
```
Then, edit the `.env` file to set your desired values for:
- `DB_NAME`: Database name (default: `wordpress`)
- `DB_USER`: Database user
- `DB_PASSWORD`: Database password
- `MYSQL_ROOT_PASSWORD`: MySQL root password

### 3. Start Docker Containers
Run the following command to build and start the containers:
```bash
$ docker-compose up --build -d
```
This will set up the `web` container with PHP and Apache, and the `db` container with MySQL.

### 4. Install WordPress
Run the provided installation script to download and set up WordPress:
```bash
$ ./receipes/wordpress/install.sh
```
This will download WordPress and copy it to the `./wordpress` directory.

### 5. Access WordPress
By default, WordPress will be available at:
- [http://localhost:8080](http://localhost:8080)

If you have modified the `.env` file, use the configured URL instead.

## Managing WordPress

### Create Database
You can create a database by running the `create_db.sh` script. By default, it will create a database named `wordpress`, or you can specify a different name as an argument:
```bash
$ ./receipes/shared/create_db.sh [database_name]
```

### Create Admin User
To create an admin user, run the `create_admin.sh` script. By default, it will create an admin user with the username `admin` and password `admin`, or you can provide custom values:
```bash
$ ./receipes/shared/create_admin.sh [admin_username] [admin_password]
```

### Reset Database
To reset the database to WordPress default settings, run the `reset_db.sh` script:
```bash
$ ./receipes/wordpress/reset_db.sh
```

## Directory Structure
- `docker-compose.yml`: Main Docker Compose configuration file.
- `.env`: Environment variables for customizing the setup.
- `wordpress/`: Directory where WordPress files are installed.
- `receipes/`: Contains scripts for managing the environment.
    - `shared/`: Shared scripts for creating databases and admin users.
    - `wordpress/`: Scripts specific to WordPress installation and database management.
- `var/`: Stores logs and other server-related data.
- `containers/`: Configuration files for Docker containers.

## Stopping the Containers
To stop the containers, run:
```bash
$ docker-compose down
```

## Additional Notes
- Ensure that you have proper permissions for the `var/`, `wordpress/`, and other relevant directories.
- The provides setup uses the latest version of MySQL and PHP with Apache.

Feel free to modify and extend this SDK to meet your specific requirements.

