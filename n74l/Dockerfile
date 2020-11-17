FROM ubuntu:20.04
LABEL version="2.0" maintainer="<André Menezes>menezesbr@gmail.com"

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y locales
RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8

RUN apt-get install -y curl build-essential locales wget unzip nano cron rsyslog supervisor
RUN apt-get install -y dos2unix gcc git libmcrypt4 libpcre3-dev memcached make

ENV TZ=America/Sao_Paulo

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y software-properties-common

RUN apt-get update -y 

RUN apt-get -y install autoconf 
RUN apt-get -y install libc-dev 
RUN apt-get -y install pkg-config 
RUN apt-get -y install libmcrypt-dev

# set the locale
RUN echo "pt_BR.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nit_IT.UTF-8 UTF-8\nnl_NL.UTF-8 UTF-8\npl_PL.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8\ntr_TR.UTF-8 UTF-8\n\n" > /etc/locale.gen && locale-gen

RUN echo "LC_ALL=pt_BR.UTF-8" >> /etc/default/locale  && \
    locale-gen pt_BR.UTF-8  && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# add some repositories
RUN apt-add-repository ppa:nginx/stable -y 
RUN apt-add-repository ppa:ondrej/php -y

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5 
RUN sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
RUN curl -s https://packagecloud.io/gpg.key | apt-key add -
RUN curl --silent --location https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update

# install nginx
RUN apt-get install -y --force-yes nginx
COPY homestead /etc/nginx/sites-available/
RUN rm -rf /etc/nginx/sites-available/default && \
    rm -rf /etc/nginx/sites-enabled/default && \
    ln -fs "/etc/nginx/sites-available/homestead" "/etc/nginx/sites-enabled/homestead" && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    usermod -u 1000 www-data && \
    chown -Rf www-data.www-data /var/www/html/ && \
    sed -i -e"s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf
VOLUME ["/var/www/html/app"]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]

# install php 7.4
RUN apt-get update
RUN apt-get install -y --force-yes php7.4-fpm php7.4-cli php7.4-dev php7.4-pgsql php7.4-sqlite3 php7.4-gd \
    php-apcu php7.4-curl php7.4-imap php7.4-mysql php7.4-readline php-xdebug php-common \
    php7.4-mbstring php7.4-xml php7.4-zip php7.4-gmp php7.4-intl php7.4-soap

RUN apt-get install -y php7.4-bcmath

RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.4/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    find /etc/php/7.4/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

COPY fastcgi_params /etc/nginx/
# RUN phpenmod mcrypt && \
RUN mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php

# install sqlite 
RUN apt-get install -y sqlite3 libsqlite3-dev  php7.4-bcmath

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc

# install nodejs
RUN apt-get install -y nodejs

# install gulp
RUN /usr/bin/npm install -g gulp

# install bower
RUN /usr/bin/npm install -g bower

# install yarn
RUN /usr/bin/npm install -g yarn

# install redis 
RUN apt-get install -y redis-server

RUN composer self-update

RUN composer config --global repo.packagist composer https://packagist.org

# install supervisor
RUN apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME ["/var/log/supervisor"]

# clean up our mess
RUN apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

WORKDIR /var/www/html/app

# expose ports
EXPOSE 80 443 6379

# set container entrypoints
ENTRYPOINT ["/bin/bash","-c"]
CMD ["/usr/bin/supervisord"]