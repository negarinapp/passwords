FROM php:7.2.12-fpm

RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
    && apt-get update && apt-get install -y libmcrypt-dev \
    mysql-client libmagickwand-dev curl --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install pdo_mysql \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
    && apt-get -y autoclean

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.13.0

COPY composer.lock composer.json /var/www/

COPY database /var/www/database

COPY . /var/www

ENV COMPOSER_ALLOW_SUPERUSER=1
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install --no-dev --no-scripts \
    && rm composer.phar

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN chown -R www-data:www-data \
        /var/www/storage \
        /var/www/bootstrap/cache

RUN a2enmod rewrite

COPY .env.example .env

RUN composer install \
    && npm install \
    && npm run production \
    && php artisan key:generate \
    && php artisan jwt:secret \
    && php artisan migrate --seed
