FROM ubuntu:18.10
LABEL version="1.0" maintainer="<André Menezes>menezesbr@gmail.com"

# set some environment variables
ENV APP_NAME app
ENV APP_EMAIL app@system.com
ENV APP_DOMAIN app.localhost
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y curl build-essential
RUN apt-get install -y locales curl wget unzip nano cron rsyslog supervisor python
RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
RUN apt-get install -y dos2unix gcc git libmcrypt4 libpcre3-dev memcached make python2.7-dev
RUN apt-get install -y python-pip re2c unattended-upgrades whois vim libnotify-bin debconf-utils
RUN apt-get install -y software-properties-common

RUN apt-get update && \
    apt-get upgrade -y 

RUN apt-get -y install gcc make autoconf libc-dev pkg-config 
RUN apt-get -y install libmcrypt-dev 

# add some repositories
RUN apt-add-repository ppa:nginx/stable -y 
RUN apt-add-repository ppa:ondrej/nginx -y
RUN apt-add-repository ppa:ondrej/php -y

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5 
RUN sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
RUN curl -s https://packagecloud.io/gpg.key | apt-key add -
RUN curl --silent --location https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update
RUN apt install apt-transport-https
    
# setup bash
COPY .bash_aliases /root

# set the locale
RUN echo "pt_BR.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nit_IT.UTF-8 UTF-8\nnl_NL.UTF-8 UTF-8\npl_PL.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8\ntr_TR.UTF-8 UTF-8\n\n" > /etc/locale.gen && locale-gen

RUN echo "LC_ALL=pt_BR.UTF-8" >> /etc/default/locale  && \
    locale-gen pt_BR.UTF-8  && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    
# install nginx
RUN apt-get install -y nginx
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

# install php 7.2
RUN apt-get install -y --force-yes php7.2-fpm php7.2-cli php7.2-dev php7.2-pgsql php7.2-sqlite3 php7.2-gd \
    php-apcu php7.2-curl php7.2-imap php7.2-mysql php7.2-readline php-xdebug php-common \
    php7.2-mbstring php7.2-xml php7.2-zip php7.2-gmp php7.2-intl php7.2-soap

RUN apt-get install -y php7.2-bcmath

RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/cli/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.2/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.2/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.2/fpm/pool.d/www.conf && \
    find /etc/php/7.2/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

RUN pecl install mcrypt-1.0.2    

RUN bash -c "echo extension=/usr/lib/php/20180731/mcrypt.so > /etc/php/7.2/cli/conf.d/mcrypt.ini"
RUN bash -c "echo extension=/usr/lib/php/20180731/mcrypt.so > /etc/php/7.2/mods-available/mcrypt.ini"

COPY fastcgi_params /etc/nginx/
# RUN phpenmod mcrypt && \
RUN mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php

# install sqlite 
RUN apt-get install -y sqlite3 libsqlite3-dev  php7.2-bcmath

# install mysql 
RUN echo mysql-server mysql-server/root_password password $DB_PASS | debconf-set-selections;\
    echo mysql-server mysql-server/root_password_again password $DB_PASS | debconf-set-selections;
RUN apt-get install -y mysql-server
RUN ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock
RUN service mysql start 
RUN service mysql start
RUN echo "[mysqld]" >> /etc/mysql/my.cnf && \
    echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf && \
    sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
    
RUN /usr/sbin/mysqld & \
    sleep 10s && \
    echo "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; CREATE USER 'probills'@'0.0.0.0' IDENTIFIED BY 'secret'; GRANT ALL ON *.* TO 'probills'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; GRANT ALL ON *.* TO 'probills'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION; FLUSH PRIVILEGES; CREATE DATABASE probills;" | mysql
VOLUME ["/var/lib/mysql"]

# # install composer
# RUN curl -sS https://getcomposer.org/installer | php && \
#     mv composer.phar /usr/local/bin/composer && \
#     printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc

# # install nodejs
# RUN apt-get install -y nodejs

# # install gulp
# RUN /usr/bin/npm install -g gulp

# # install bower
# RUN /usr/bin/npm install -g bower

# # install yarn
# RUN /usr/bin/npm install -g yarn

# # install redis 
# RUN apt-get install -y redis-server

# install blackfire
# RUN apt-get install -y blackfire-agent blackfire-php

# install beanstalkd
# RUN apt-get install -y beanstalkd && \
#     sed -i "s/BEANSTALKD_LISTEN_ADDR.*/BEANSTALKD_LISTEN_ADDR=0.0.0.0/" /etc/default/beanstalkd && \
#     sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd && \
#     /etc/init.d/beanstalkd start

# # Laravel Envoy
# RUN composer global require laravel/envoy

# # Prestissimo
# RUN composer global require hirak/prestissimo

# RUN composer self-update

# RUN composer config --global repo.packagist composer https://packagist.org

# # install supervisor
# RUN apt-get install -y supervisor && \
#     mkdir -p /var/log/supervisor
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# VOLUME ["/var/log/supervisor"]

# # clean up our mess
# RUN apt-get remove --purge -y software-properties-common && \
#     apt-get autoremove -y && \
#     apt-get clean && \
#     apt-get autoclean && \
#     echo -n > /var/lib/apt/extended_states && \
#     rm -rf /var/lib/apt/lists/* && \
#     rm -rf /usr/share/man/?? && \
#     rm -rf /usr/share/man/??_*

# WORKDIR /var/www/html/app

# # expose ports
# EXPOSE 80 443 3306 6379

# # set container entrypoints
# ENTRYPOINT ["/bin/bash","-c"]
# CMD ["/usr/bin/supervisord"]