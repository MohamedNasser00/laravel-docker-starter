#!/bin/bash

set -e

cd /var/www/html


# ---------------------------------------------------------------------------- #
# Create required directories
# ---------------------------------------------------------------------------- #

mkdir -p \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    storage/logs \
    bootstrap/cache


# ---------------------------------------------------------------------------- #
# Set permissions
# ---------------------------------------------------------------------------- #

chmod -R 775 storage bootstrap/cache 2>/dev/null || true


# ---------------------------------------------------------------------------- #
# Create .env if missing
# ---------------------------------------------------------------------------- #

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
    fi
fi


# ---------------------------------------------------------------------------- #
# Composer install
# ---------------------------------------------------------------------------- #

if [ -f composer.lock ]; then

    CURRENT_HASH=$(sha1sum composer.lock | awk '{print $1}')
    STORED_HASH=""

    if [ -f vendor/.composer-hash ]; then
        STORED_HASH=$(cat vendor/.composer-hash)
    fi

    if [ "$CURRENT_HASH" != "$STORED_HASH" ]; then

        composer install \
            --no-interaction \
            --no-progress \
            --prefer-dist \
            --optimize-autoloader

        echo "$CURRENT_HASH" > vendor/.composer-hash

    fi

fi


# ---------------------------------------------------------------------------- #
# Laravel initialization
# ---------------------------------------------------------------------------- #

if [ -f artisan ]; then


    # Generate APP_KEY only if missing

    if grep -q "^APP_KEY=$" .env 2>/dev/null; then
        php artisan key:generate --force
    fi


    # Clear old cached config

    php artisan config:clear || true

fi


# ---------------------------------------------------------------------------- #
# Clear OPcache file cache
# ---------------------------------------------------------------------------- #

rm -rf /tmp/opcache/* || true


# ---------------------------------------------------------------------------- #
# Execute command
# ---------------------------------------------------------------------------- #

exec "$@"
