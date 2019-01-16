FROM menezesbr/servers:u14.04n
MAINTAINER André Menezes <menezesbr@gmail.com>

ENV APP_PATH /var/www/html/app

# upgrade the container
RUN apt-get update -y

# install nginx
RUN apt-get install -y --force-yes nginx

RUN rm -rf /etc/nginx/sites-available/default && \
    rm -rf /etc/nginx/sites-enabled/default && \
    ln -fs "/etc/nginx/sites-available/homestead" "/etc/nginx/sites-enabled/homestead" && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    usermod -u 1000 www-data && \
    chown -Rf www-data.www-data /var/www/html/ && \
    sed -i -e"s/worker_processes 1/worker_processes 5/" /etc/nginx/nginx.conf
VOLUME [$APP_PATH]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]

WORKDIR $APP_PATH
COPY homestead /etc/nginx/sites-available/
COPY cacert.pem /usr/local/ssl/cert.pem

# install php
RUN apt-get install -y --force-yes php7.1-fpm php7.1-cli php7.1-dev php7.1-pgsql php7.1-sqlite3 php7.1-gd \
    php-apcu php7.1-curl php7.1-mcrypt php7.1-imap php7.1-mysql php7.1-readline php-xdebug php-common \
    php7.1-mbstring php7.1-xml php7.1-zip php7.1-gmp php7.1-soap php7.1-bcmath php7.1-intl 
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;extension=php_gmp.so.*/extension=php_gmp.so/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;extension=php_gmp.so.*/extension=php_gmp.so/" /etc/php/7.1/cli/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    find /etc/php/7.1/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

COPY fastcgi_params /etc/nginx/
RUN phpenmod mcrypt && \
    mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php

# install sqlite 
RUN apt-get install -y sqlite3 libsqlite3-dev

# install redis 
RUN add-apt-repository ppa:chris-lea/redis-server -y 
RUN apt-get install -y redis-server

# install beanstalkd
RUN apt-get install -y --force-yes beanstalkd && \
    sed -i "s/BEANSTALKD_LISTEN_ADDR.*/BEANSTALKD_LISTEN_ADDR=0.0.0.0/" /etc/default/beanstalkd && \
    sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd && \
    /etc/init.d/beanstalkd start

# Install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc 

# Add Scripts
ADD scripts/letsencrypt-setup /usr/bin/letsencrypt-setup
ADD scripts/letsencrypt-renew /usr/bin/letsencrypt-renew
RUN chmod 755 /usr/bin/letsencrypt-setup && chmod 755 /usr/bin/letsencrypt-renew
# ADD scripts/start.sh /start.sh
# ADD scripts/pull /usr/bin/pull
# ADD scripts/push /usr/bin/push
# RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push && chmod 755 /usr/bin/letsencrypt-setup && chmod 755 /usr/bin/letsencrypt-renew && chmod 755 /start.sh

# install supervisor
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

# expose ports
EXPOSE 80 443 6379

# set container entrypoints
ENTRYPOINT ["/bin/bash","-c"]
CMD ["/usr/bin/supervisord"]