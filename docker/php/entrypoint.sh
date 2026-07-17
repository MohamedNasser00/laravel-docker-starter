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
# Permissions
# ---------------------------------------------------------------------------- #

chmod -R ug+rwx storage bootstrap/cache 2>/dev/null || true


# ---------------------------------------------------------------------------- #
# Create .env
# ---------------------------------------------------------------------------- #

if [ ! -f .env ] && [ -f .env.example ]; then
    cp .env.example .env
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


        mkdir -p vendor

        echo "$CURRENT_HASH" > vendor/.composer-hash

    fi

fi


# ---------------------------------------------------------------------------- #
# Laravel initialization
# ---------------------------------------------------------------------------- #

if [ -f artisan ] && [ -f .env ]; then


    if grep -q "^APP_KEY=$" .env; then

        echo "Generating APP_KEY..."

        php artisan key:generate --force

    fi


    php artisan optimize:clear || true

fi


# ---------------------------------------------------------------------------- #
# Clear OPcache
# ---------------------------------------------------------------------------- #

rm -rf /tmp/opcache/* 2>/dev/null || true


# ---------------------------------------------------------------------------- #
# Start service
# ---------------------------------------------------------------------------- #

exec "$@"
