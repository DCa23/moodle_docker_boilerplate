FROM php:8.3-apache

# Install dependencies
RUN apt-get update 

RUN apt-get install -y \
    curl git unzip libzip-dev \
    libpng-dev libjpeg-dev \
    libfreetype6-dev libicu-dev \
    libonig5 libonig-dev libxml2-dev

# Install MDK requirements
RUN apt-get install -y python3 python3-pip python3-venv \
    libpq-dev python3-dev unixodbc-dev default-libmysqlclient-dev


# PHP / Apche configs

RUN docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure mbstring --disable-mbregex && \
    docker-php-ext-install -j$(nproc) pdo_mysql mysqli gd zip intl mbstring soap exif && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    a2enmod rewrite

RUN python3 -m venv /var/mdk

WORKDIR /var/www/html

CMD ["apache2-foreground"]