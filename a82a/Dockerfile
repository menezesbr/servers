FROM ubuntu:22.04

# Set default environment variables
ENV TIMEZONE America/Sao_Paulo

# Disable debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Add PHP PPA Repository
RUN apt-get update \
    && apt-get install -y software-properties-common rpl zip unzip git nano vim curl wget nano p7zip-full tzdata

# Set Timezone
RUN ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Install Apache, PHP and PHP modules
RUN apt-get install -y apache2 

RUN rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:ondrej/php

RUN apt-get install -y --no-install-recommends php8.2 libapache2-mod-php php-soap php-xml php-curl php-gd php-sqlite3 \
        php-mbstring php8.2-cli php-common php8.2-common php8.2-opcache php8.2-readline php8.2-xml \
       php8.2-intl php8.2-mbstring php8.2-soap php8.2-curl php8.2-zip php8.2-mysql \
       php8.2-xdebug php8.2-memcached php8.2-gd php-mbstring php8.2-bcmath \
       php8.2-bz2 php8.2-xmlrpc php8.2-xsl php8.2-yaml php8.2-zmq \
       php8.2-dev php-pear build-essential libaio1 composer php8.2-sqlite3 php8.2-pgsql \
       php8.2-mysql php8.2-pdo-dblib php8.2-pdo-firebird php8.2-pdo-odbc

RUN apt-get install -y mysql-client postgresql-client sqlite3

RUN apt install -y php-xdebug

# Configure XDebug
RUN echo "zend_extension=xdebug" > /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "[xdebug]" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "; xdebug.mode = coverage" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "; xdebug.mode = develop" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.mode = debug" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.remote_enable = 1" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.remote_connect_back = 0" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.remote_autostart = 1" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.start_with_request = yes" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.discover_client_host = 1" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.client_port=9009" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.idekey = VSCODE" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.client_host = host.docker.internal" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.idekey = PHPSTORM" >> /etc/php/8.2/cli/conf.d/20-xdebug.ini


# Clean apt-get cache and temporary files
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

# Disable/Enable modules
RUN a2dismod mpm_event \
    && a2dismod mpm_worker \
    && a2enmod mpm_prefork \
    && a2enmod php8.2 \
    && a2enmod rewrite

# Enable .htaccess reading
RUN LANG="en_US.UTF-8" rpl "AllowOverride None" "AllowOverride All" /etc/apache2/apache2.conf

# Set PHP default environment vars
ENV PHP_DISPLAY_ERRORS On
ENV PHP_ERROR_REPORTING E_ALL

# Set PHP custom settings
RUN echo "\n# Custom settings"                                    >> /etc/php/8.2/apache2/php.ini \
    && echo "error_log = /tmp/php_errors.log"                     >> /etc/php/8.2/apache2/php.ini \
    && echo "memory_limit = 256M"                                 >> /etc/php/8.2/apache2/php.ini \
    && echo "max_execution_time = 120"                            >> /etc/php/8.2/apache2/php.ini \
    && echo "file_uploads = On"                                   >> /etc/php/8.2/apache2/php.ini \
    && echo "post_max_size = 100M"                                >> /etc/php/8.2/apache2/php.ini \
    && echo "upload_max_filesize = 100M"                          >> /etc/php/8.2/apache2/php.ini \
    && echo "session.gc_maxlifetime = 14000"                      >> /etc/php/8.2/apache2/php.ini \
    && echo "display_errors = On"                                 >> /etc/php/8.2/apache2/php.ini \
    && echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT" >> /etc/php/8.2/apache2/php.ini

# Set PHP security settings
RUN echo "\n# Security settings"                    >> /etc/php/8.2/apache2/php.ini \
    && echo "session.name = CUSTOMSESSID"           >> /etc/php/8.2/apache2/php.ini \
    && echo "session.use_only_cookies = 1"          >> /etc/php/8.2/apache2/php.ini \
    && echo "session.cookie_httponly = true"        >> /etc/php/8.2/apache2/php.ini \
    && echo "session.use_trans_sid = 0"             >> /etc/php/8.2/apache2/php.ini \
    && echo "session.entropy_file = /dev/urandom"   >> /etc/php/8.2/apache2/php.ini \
    && echo "session.entropy_length = 32"           >> /etc/php/8.2/apache2/php.ini

# Link log and error files to stdout
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# Defines directories that can be mapped
WORKDIR /var/www/html
VOLUME ["/var/www/html", "/tmp", "/var/log/apache2", "/etc/apache2"]

# Expose webserver port
EXPOSE 80

CMD ["apachectl", "-DFOREGROUND"]