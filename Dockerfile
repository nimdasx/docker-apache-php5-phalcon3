#sama dengan 5.6-apache-stretch
#basisnya dari debian 9	Stretch
FROM php:5.6-apache

LABEL maintainer="nimdasx@gmail.com"
LABEL description="Apache PHP-5.6 Phalcon-3.4.5"

#config
COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini
COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY docker-php.conf /etc/apache2/conf-enabled/docker-php.conf

#cemacem
RUN a2enmod rewrite remoteip && \
    ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# perbarui apt stretch pindah ke archive karena sudah tidak di support
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# dependensi
RUN apt-get -y update && \
    apt-get install -y --allow-unauthenticated \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
    unzip \
    libpng-dev \
    libpq-dev \
    gnupg \
    gnupg2 \
    gnupg1 \
    git \
    freetds-dev \
    libsybdb5 && \
    ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/ && \
    rm -rf /var/lib/apt/lists/*

# php ext 
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
    docker-php-ext-install zip mysqli pdo_mysql pdo_pgsql gd mssql pdo_dblib

# phalcon
COPY cphalcon-3.4.5.zip /usr/local/src/
RUN cd /usr/local/src && \
    unzip cphalcon-3.4.5.zip && \
    cd cphalcon-3.4.5/build && \
    ./install && \
    cd / && \
    rm -rf /usr/local/src/* && \
    docker-php-ext-enable phalcon

# redis - install extension compatible with PHP 5.6
RUN pecl install -o -f redis-3.1.6 && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis