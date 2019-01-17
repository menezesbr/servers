FROM php:7.2-apache
LABEL version="1.2" maintainer="menezesbr@gmail.com"

# If building on a RPi, use --build-arg cores=3 to use all cores when compiling
# to speed up the image build
ARG CORES
ENV CORES ${CORES:-1}

ENV APP_PATH /var/www/app/
ENV CURL_VERSION 7.60.0
ENV OPENSSL_VERSION 1.1.1-pre6
ENV COMPOSER_ALLOW_SUPERUSER 1


# install packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends libcurl4-openssl-dev \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    wget \
    libpng-dev \
    libicu-dev \
    libldap2-dev \
    libedit-dev \
    libtidy-dev \
    libxml2-dev \
    unzip \
    libsqlite3-dev \
    nano \
    libpq-dev \
    libbz2-dev \
    gettext-base \
    cron \
    rsyslog \
    supervisor \
    locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# LDAP install
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && docker-php-ext-install ldap

RUN apt-get update -y
RUN apt-get install -y libgmp-dev re2c libmhash-dev libmcrypt-dev file
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/

RUN docker-php-ext-configure gmp && docker-php-ext-install gmp
RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN docker-php-ext-configure soap && docker-php-ext-install soap

# Install latest curl
RUN cd /tmp && \
    wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    tar -xvf openssl-${OPENSSL_VERSION}.tar.gz && \
    cd openssl-${OPENSSL_VERSION} && \
    ./config && \
    make -j${CORES} && \
    make install

RUN cd /tmp && \
    wget https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz && \
    tar -xvf curl-${CURL_VERSION}.tar.gz && \
    cd curl-${CURL_VERSION} && \
    ./configure --with-ssl --host=$(gcc -dumpmachine) && \
    make -j${CORES} && \
    make install

# Make sure that libcurl is using the newer curl libaries
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/00-curl.conf && ldconfig

# Mimic the Debian/Ubuntu config file structure for supervisor
COPY .deploy/docker/supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /etc/supervisor/conf.d /var/log/supervisor

# copy supervisor conf file.
COPY ./.deploy/docker/app.conf /etc/supervisor/conf.d/app.conf

# copy cron job supervisor conf file.
COPY ./.deploy/docker/cronjob.conf /etc/supervisor/conf.d/cronjob.conf

# copy ca certs to correct location
COPY ./.deploy/docker/cacert.pem /usr/local/ssl/cert.pem

# test crons added via crontab
RUN echo "0 3 * * * /usr/local/bin/php /var/www/app/artisan app:cron" | crontab -
#RUN (crontab -l ; echo "*/1 * * * * free >> /var/www/dragonfly-I/public/cron.html") 2>&1 | crontab -

# Install PHP exentions.
RUN docker-php-ext-install -j$(nproc) gd tidy zip bcmath pdo_mysql bz2 pdo_pgsql

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Generate locales supported 
RUN echo "pt_BR.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nit_IT.UTF-8 UTF-8\nnl_NL.UTF-8 UTF-8\npl_PL.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8\ntr_TR.UTF-8 UTF-8\n\n" > /etc/locale.gen && locale-gen

# copy Apache config to correct spot.
COPY ./.deploy/docker/apache2.conf /etc/apache2/apache2.conf

# Enable apache mod rewrite..
RUN a2enmod rewrite

# Enable apache mod ssl..
RUN a2enmod ssl

# upgrade the container
RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y nano zip unzip p7zip-full

# install nodejs
RUN apt-get install -y nodejs

# Create volumes
VOLUME $APP_PATH $APP_PATH/storage/export $APP_PATH/storage/upload

# Enable default site
COPY ./.deploy/docker/apache-app.conf /etc/apache2/sites-available/000-default.conf

# Make sure we own directory
RUN chown -R www-data:www-data /var/www && chmod -R 775 $APP_PATH/storage

# Copy in Dragonfly Source
WORKDIR $APP_PATH
ADD . $APP_PATH

# Fix the link to curl:
RUN rm -rf /usr/local/lib/libcurl.so.4 && ln -s /usr/lib/x86_64-linux-gnu/libcurl.so.4.4.0 /usr/local/lib/libcurl.so.4

# Add Scripts
ADD scripts/letsencrypt-setup /usr/bin/letsencrypt-setup
ADD scripts/letsencrypt-renew /usr/bin/letsencrypt-renew
RUN chmod 755 /usr/bin/letsencrypt-setup && chmod 755 /usr/bin/letsencrypt-renew

EXPOSE 443 80







# ADD scripts/start.sh /start.sh
# ADD scripts/pull /usr/bin/pull
# ADD scripts/push /usr/bin/push
# RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push && && chmod 755 /start.sh


# Run composer
#RUN composer install --prefer-dist --no-dev --no-scripts --no-suggest

# Expose port 80

# make sure the correct directories exists (suggested by @chrif):
# RUN mkdir -p $APP_PATH/storage/app
# RUN mkdir -p $APP_PATH/storage/app/public
# RUN mkdir -p $APP_PATH/storage/build
# RUN mkdir -p $APP_PATH/storage/database
# RUN mkdir -p $APP_PATH/storage/debugbar
# RUN mkdir -p $APP_PATH/storage/export
# RUN mkdir -p $APP_PATH/storage/framework/cache
# RUN mkdir -p $APP_PATH/storage/framework/sessions
# RUN mkdir -p $APP_PATH/storage/framework/testing
# RUN mkdir -p $APP_PATH/storage/framework/views
# RUN mkdir -p $APP_PATH/storage/logs
# RUN mkdir -p $APP_PATH/storage/upload

# make sure we own the volumes:
# RUN chown -R www-data:www-data -R /var/www/app/storage
# RUN chmod -R 775 /var/www/app/storage

# remove any lingering files that may break upgrades:
# RUN rm -f /var/www/app/storage/logs/laravel.log

# cat .env.docker | envsubst > .env
# composer dump-autoload
# php artisan package:discover
# php artisan firefly:instructions install
# RUN exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon

# Run entrypoint thing
# ENTRYPOINT [".deploy/docker/entrypoint.sh"]