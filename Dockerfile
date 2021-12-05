FROM php:5.6.40-apache-stretch

LABEL maintainer="nimdasx@gmail.com"
LABEL description="Apache PHP 5.6.40 Phalcon 3.4.5"

COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini

#cemacem
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \ 
    && apt-get -y update \
    && apt-get install -y \
    unzip \
    libpng-dev \
    freetds-dev \
    libsybdb5 \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite \
    && sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/-Indexes/+Indexes/' /etc/apache2/conf-enabled/docker-php.conf \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/ \
    && docker-php-ext-install pdo_mysql gd mssql pdo_dblib zip

#gd
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    && docker-php-ext-install -j "$(nproc)" gd

#phalcon
COPY cphalcon-3.4.5.zip .
RUN unzip cphalcon-3.4.5.zip -d /usr/local/src
WORKDIR /usr/local/src/cphalcon-3.4.5/build
RUN ./install
WORKDIR /
RUN rm -f /var/www/html/cphalcon-3.4.5.zip \
    && rm -rf /usr/local/src/* \
    && docker-php-ext-enable phalcon