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
# Set ownership and permissions
# ---------------------------------------------------------------------------- #

chown -R www-data:www-data storage bootstrap/cache 2>/dev/null || true
chmod -R 775 storage bootstrap/cache 2>/dev/null || true

# ---------------------------------------------------------------------------- #
# Clear OPcache file cache
# ---------------------------------------------------------------------------- #

rm -rf /tmp/opcache/*

# ---------------------------------------------------------------------------- #
# Composer install (only if dependencies changed)
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
# Execute the provided command
# ---------------------------------------------------------------------------- #

exec "$@"
