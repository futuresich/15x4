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

ARG ADMIN_PASSWORD
ARG APP_SECRET
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

RUN echo "DB_NAME=${DB_NAME}"
RUN echo "DB_USER=${DB_USER}"

RUN sed -e 's|\$APP_SECRET|'${APP_SECRET}'|g' \
        -e 's|\$DB_PASSWORD|'${DB_PASSWORD}'|g' \
        -e 's|\$DB_USER|'${DB_USER}'|g' \
        -e 's|\$DB_NAME|'${DB_NAME}'|g' \
        -e 's|\$ADMIN_PASSWORD|'${ADMIN_PASSWORD}'|g' \
        /var/www/html/app/config/parameters.yml.dist > /var/www/html/app/config/parameters.yml

# Set ownership of the /var/www/html/var directory to www-data
RUN chown -R www-data:www-data /var/www/html/var
RUN chmod -R 775 /var/www/html/var

CMD ["bash", "-c", "composer install --no-interaction && apache2-foreground"]