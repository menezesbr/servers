FROM menezesbr/servers:u14.04n
MAINTAINER André Menezes <menezesbr@gmail.com>

# set some environment variables
ENV APP_NAME Server_Apache_PHP

# upgrade the container
RUN apt-get update -y
RUN apt-get upgrade -y

# install Apache2
RUN apt-get install -y --force-yes apache2 p7zip-full

# install php 7
RUN apt-get install -y --force-yes php7.0-fpm php7.0-cli php7.0-dev php7.0-pgsql php7.0-sqlite3 php7.0-gd \
    php-apcu php7.0-curl php7.0-mcrypt php7.0-imap php7.0-mysql php7.0-readline php-xdebug php-common \
    php7.0-mbstring php7.0-xml php7.0-zip php7.0-gmp php7.0-bcmath php7.0-common php7.0-bcmath php7.0-intl php7.0-gmp

# install php 7.1
RUN apt-get install -y --force-yes php7.1 php7.1-gmp php7.1-bcmath php7.1-curl php7.1-xml \
    php7.1-soap php7.1-fpm php7.1-cli php7.1-common php7.1-mbstring php7.1-gd php7.1-intl \
    php7.1-xml php7.1-mysql php7.1-mcrypt php7.1-zip php5.6-xml       

RUN a2enmod php7.1

RUN service apache2 restart

VOLUME ["/var/www/html"]
VOLUME ["/etc/apache2"]
VOLUME ["/etc/php/7.1/apache2/"] 

RUN usermod -u 1000 www-data && \
    chown -Rf www-data.www-data /var/www/html/

RUN phpenmod mcrypt && \
    mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php


# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc


# install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME ["/etc/supervisor/conf.d/"]
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
EXPOSE 80 443

RUN service apache2 restart

RUN a2enmod php7.1

RUN service apache2 restart

# set container entrypoints
ENTRYPOINT ["/bin/bash","-c"]
CMD ["/usr/bin/supervisord"]


#RUN update-rc.d apache2 enable
    