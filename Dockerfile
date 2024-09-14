FROM php:7.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    mariadb-client \
    libicu-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install intl mbstring zip mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./apache.conf /etc/apache2/sites-available/15x4.conf
RUN a2ensite 15x4.conf && a2dissite 000-default.conf

# Enable Apache mod_rewrite (for Symfony and other PHP frameworks)
RUN a2enmod rewrite

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the project to the working directory
COPY . /var/www/html

# Install PHP dependencies
RUN composer install --no-interaction

# Make sure the Apache server runs in the foreground
CMD ["apache2-foreground"]