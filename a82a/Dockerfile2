FROM php:8.2-fpm

RUN apt-get update
RUN apt-get install apache2 php libapache2-mod-php
RUN apt-get install php-soap php-xml php-curl php-opcache php-gd php-sqlite3 php-mbstring
RUN apt-get install rpl zip unzip git vim curl

RUN a2dismod mpm_event
RUN a2dismod mpm_worker
RUN a2enmod  mpm_prefork
RUN a2enmod  rewrite
RUN a2enmod  php8.2

# DEVELOPMENT
RUN echo "" >> /etc/php/8.2/apache2/php.ini
RUN echo "error_log = /tmp/php_errors.log" >> /etc/php/8.2/apache2/php.ini
RUN echo "display_errors = On"             >> /etc/php/8.2/apache2/php.ini
RUN echo "memory_limit = 256M"             >> /etc/php/8.2/apache2/php.ini
RUN echo "max_execution_time = 120"        >> /etc/php/8.2/apache2/php.ini
RUN echo "error_reporting = E_ALL"         >> /etc/php/8.2/apache2/php.ini
RUN echo "file_uploads = On"               >> /etc/php/8.2/apache2/php.ini
RUN echo "post_max_size = 100M"            >> /etc/php/8.2/apache2/php.ini
RUN echo "upload_max_filesize = 100M"      >> /etc/php/8.2/apache2/php.ini
RUN echo "session.gc_maxlifetime = 14000"  >> /etc/php/8.2/apache2/php.ini

# PRODUCTION
# RUN echo "display_errors = Off" >> php.ini
# RUN echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE" >> php.ini

RUN service apache2 restart

# SECURITY
RUN echo "session.name = CUSTOMSESSID"   >> /etc/php/8.2/apache2/php.ini
RUN echo "session.use_only_cookies = 1"        >> /etc/php/8.2/apache2/php.ini
RUN echo "session.cookie_httponly = true"      >> /etc/php/8.2/apache2/php.ini
RUN echo "session.use_trans_sid = 0"           >> /etc/php/8.2/apache2/php.ini
RUN echo "session.entropy_file = /dev/urandom" >> /etc/php/8.2/apache2/php.ini
RUN echo "session.entropy_length = 32"         >> /etc/php/8.2/apache2/php.ini

RUN apt-get install libapache2-mod-evasive
RUN a2enmod evasive

RUN rm /etc/apache2/mods-enabled/evasive.conf
RUN 
RUN echo '<IfModule mod_evasive20.c>'             >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '  DOSHashTableSize 2048'                >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '  DOSPageCount 10'                      >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '  DOSSiteCount 200'                     >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '  DOSPageInterval 2'                    >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '  DOSSiteInterval 2'                    >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '  DOSBlockingPeriod 10'                 >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '  DOSLogDir "/var/log/apache2/evasive"' >> /etc/apache2/mods-enabled/evasive.conf
RUN echo '</IfModule>'                            >> /etc/apache2/mods-enabled/evasive.conf

RUN rpl "AllowOverride None" "AllowOverride All" /etc/apache2/apache2.conf
RUN service apache2 restart

VOLUME [ "/var/www/html/" ]
EXPOSE 80