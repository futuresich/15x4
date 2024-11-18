#!/bin/bash
set -e

# Perform variable substitution
envsubst < /var/www/html/app/config/parameters.yml.dist > /var/www/html/app/config/parameters.yml

# Install Composer dependencies
composer install --no-interaction

# Start Apache in the foreground
exec apache2-foreground