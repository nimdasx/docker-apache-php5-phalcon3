FROM php:5.6.40-apache-stretch

LABEL maintainer="nimdasx@gmail.com"
LABEL description="Apache PHP 5.6.40 Phalcon 3.4.5"

#set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

#install unzip
RUN apt-get -y update \
&& apt-get install -y \
unzip \
libpng-dev \
gnupg \
gnupg2 \
gnupg1 \
apt-transport-https \
ca-certificates \
&& rm -rf /var/lib/apt/lists/*

#install phalcon
COPY cphalcon-3.4.5.zip /usr/local/src/
WORKDIR /usr/local/src
RUN unzip cphalcon-3.4.5.zip
WORKDIR /usr/local/src/cphalcon-3.4.5/build
RUN ./install
WORKDIR /
RUN rm -rf /usr/local/src/*
#enable phalcon
RUN docker-php-ext-enable phalcon

RUN docker-php-ext-install pdo_mysql gd

# config php
COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini

# apache
RUN a2enmod rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/-Indexes/+Indexes/' /etc/apache2/conf-enabled/docker-php.conf

#sqlsrv
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y \
    msodbcsql17 \
    mssql-tools \
    unixodbc-dev \
    libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && sed -i 's/TLSv1.2/TLSv1.0/g' /etc/ssl/openssl.cnf