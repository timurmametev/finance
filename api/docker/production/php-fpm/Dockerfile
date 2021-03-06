FROM php:8.1-cli-alpine AS builder

RUN apk add unzip

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet

WORKDIR /app

COPY ./composer.json ./composer.lock ./

RUN composer install --no-dev --prefer-dist --no-progress --no-suggest --optimize-autoloader \
    && rm -rf /root/.composer/cache

###

FROM php:8.1-fpm-alpine

RUN docker-php-ext-install opcache

RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

COPY ./docker/common/php/conf.d /urs/local/etc/php/conf.d
COPY ./docker/production/php/conf.d /urs/local/etc/php/conf.d

WORKDIR /app

COPY --from=builder /app ./
COPY ./ ./