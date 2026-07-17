#!/bin/bash

set -e

echo "Starting Laravel installation..."

cd /var/www/html


# ---------------------------------------------------------------------------- #
# Environment
# ---------------------------------------------------------------------------- #

if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
fi


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

if ! grep -q "APP_KEY=base64:" .env; then
    echo "Generating application key..."
    php artisan key:generate --force
fi


# ---------------------------------------------------------------------------- #
# Storage
# ---------------------------------------------------------------------------- #

echo "Creating storage link..."

php artisan storage:link || true


# ---------------------------------------------------------------------------- #
# Database Tables
# ---------------------------------------------------------------------------- #

echo "Preparing Laravel database tables..."

php artisan session:table || true
php artisan cache:table || true
php artisan queue:table || true

# ---------------------------------------------------------------------------- #
# Wait for Database
# ---------------------------------------------------------------------------- #

echo "Waiting for MySQL..."

until php -r "
try {
    new PDO(
        'mysql:host=' . getenv('DB_HOST') . ';port=' . getenv('DB_PORT') . ';dbname=' . getenv('DB_DATABASE'),
        getenv('DB_USERNAME'),
        getenv('DB_PASSWORD')
    );
    exit(0);
} catch (Exception \$e) {
    exit(1);
}
"; do
    echo "MySQL is not ready yet..."
    sleep 2
done

echo "MySQL is ready."

# ---------------------------------------------------------------------------- #
# Migration
# ---------------------------------------------------------------------------- #

echo "Running migrations..."

php artisan migrate --force


# ---------------------------------------------------------------------------- #
# Node Dependencies & Frontend Build
# ---------------------------------------------------------------------------- #

if [ -f package.json ]; then

    echo "Installing Node dependencies..."

    npm install


    if grep -q '"build"' package.json; then

        echo "Building frontend assets..."

        npm run build

    else

        echo "No build script found. Skipping frontend build."

    fi

else

    echo "No package.json found. Skipping Node setup."

fi

# ---------------------------------------------------------------------------- #
# Permissions
# ---------------------------------------------------------------------------- #

echo "Fixing permissions..."

chmod -R ug+rwx storage bootstrap/cache || true

echo ""
echo "Laravel installation completed successfully!"
