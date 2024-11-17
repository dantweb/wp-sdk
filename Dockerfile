# Dockerfile (containers/php/Dockerfile)
FROM php:8.2-apache

# Install dependencies and enable necessary PHP extensions
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip unzip curl less sendmail && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd mysqli && \
    a2enmod rewrite && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create a non-root user
RUN useradd -ms /bin/bash wordpressuser

# Switch to the non-root user
USER wordpressuser

# Copy custom configuration files (if any)
COPY ./containers/php/apache-config.conf /etc/apache2/sites-available/000-default.conf
