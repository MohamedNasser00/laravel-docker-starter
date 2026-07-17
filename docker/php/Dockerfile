# ---------------------------------------------------------------------------- #
# Base image
# ---------------------------------------------------------------------------- #

FROM php:8.4-fpm


# ---------------------------------------------------------------------------- #
# System dependencies
# ---------------------------------------------------------------------------- #

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    unzip \
    rsync \
    ca-certificates \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------- #
# PHP extensions
# ---------------------------------------------------------------------------- #

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        bcmath \
        gd \
        intl \
        zip \
        exif \
        pcntl


# ---------------------------------------------------------------------------- #
# Composer
# ---------------------------------------------------------------------------- #

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1


# ---------------------------------------------------------------------------- #
# Node.js 22 LTS
# ---------------------------------------------------------------------------- #

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------- #
# Working directory
# ---------------------------------------------------------------------------- #

WORKDIR /var/www/html


# ---------------------------------------------------------------------------- #
# PHP configuration
# ---------------------------------------------------------------------------- #

COPY docker/php/opcache.dev.ini $PHP_INI_DIR/conf.d/opcache.ini

COPY docker/php/uploads.ini $PHP_INI_DIR/conf.d/uploads.ini


RUN mkdir -p /tmp/opcache


# ---------------------------------------------------------------------------- #
# Entrypoint
# ---------------------------------------------------------------------------- #

COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh


ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["php-fpm"]
