#!/bin/bash

set -e

echo "Starting Laravel setup..."

cd /var/www/html


# ---------------------------------------------------------------------------- #
# Composer
# ---------------------------------------------------------------------------- #

echo "Installing Composer dependencies..."

composer install \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader


# ---------------------------------------------------------------------------- #
# Application Key
# ---------------------------------------------------------------------------- #

if grep -q "^APP_KEY=$" .env 2>/dev/null; then

    echo "Generating application key..."

    php artisan key:generate --force

fi


# ---------------------------------------------------------------------------- #
# Laravel cache
# ---------------------------------------------------------------------------- #

echo "Clearing Laravel cache..."

php artisan config:clear

php artisan optimize:clear || true


# ---------------------------------------------------------------------------- #
# Storage
# ---------------------------------------------------------------------------- #

echo "Creating storage link..."

php artisan storage:link || true


# ---------------------------------------------------------------------------- #
# Frontend
# ---------------------------------------------------------------------------- #

if [ -f package.json ]; then

    echo "Installing Node dependencies..."

    npm install

fi


# ---------------------------------------------------------------------------- #
# Permissions
# ---------------------------------------------------------------------------- #

echo "Fixing permissions..."

chmod -R ug+rwx storage bootstrap/cache || true


echo ""
echo "Laravel setup completed successfully!"
