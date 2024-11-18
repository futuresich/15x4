# Dockerfile

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
    gettext-base \
    && docker-php-ext-install intl mbstring zip mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./apache.conf /etc/apache2/sites-available/15x4.conf
RUN a2ensite 15x4.conf && a2dissite 000-default.conf

RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html/var
RUN chmod -R 775 /var/www/html/var
RUN composer install --no-interaction --no-progress
RUN bin/console assets:install --symlink
RUN bin/console assetic:dump --env=prod --no-debug

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]