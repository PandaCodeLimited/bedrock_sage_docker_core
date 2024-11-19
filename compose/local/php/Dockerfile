# define an alias for the specific php version used in this file.
FROM php:8.3-fpm AS base

# Python build stage
FROM base AS php
LABEL name=bedrock
LABEL intermediate=true
ARG BUILD_ENVIRONMENT=local
ARG APP_HOME=/app

# Install essential packages
RUN apt-get update \
  && apt-get install -y \
    build-essential \
    curl \
    git \
    gnupg \
    less \
    nano \
    vim \
    unzip \
    zip \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# Install php extensions and related packages
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync \
  && install-php-extensions \
    @composer \
    exif \
    gd \ 
    memcached \
    mysqli \
    pcntl \
    pdo_mysql \
    zip \
  && apt-get update \
  && apt-get install -y \
    gifsicle \
    jpegoptim \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libmemcached-dev \
    locales \
    lua-zlib-dev \
    optipng \
    pngquant \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# Install nginx & supervisor
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash \
  && apt-get update \
  && apt-get install -y \
    nginx \
    nodejs \
    supervisor \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && npm install -g yarn

# Start install
RUN mkdir /var/www/pandacode
COPY ./.envs/.local/supervisord.conf /etc/supervisord.conf
COPY ./.envs/.local/wp.conf /var/www/pandacode/.env
COPY ./config /var/www/pandacode/config
COPY ./web /var/www/pandacode/web
COPY ./composer.json /var/www/pandacode/composer.json
COPY ./compose/local/php/start /var/www/pandacode/start.sh

COPY ./.envs/.local/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./.envs/.local/nginx/sites-enabled /etc/nginx/conf.d
COPY ./.envs/.local/nginx/sites-enabled /etc/nginx/sites-enabled

RUN chmod -R 777 /var/www/pandacode/web/app/uploads

RUN chmod +x /var/www/pandacode/start.sh

# default entry point.
ENTRYPOINT ["sh", "/var/www/pandacode/start.sh"]
