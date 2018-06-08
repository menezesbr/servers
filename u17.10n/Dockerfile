FROM ubuntu:17.10
MAINTAINER André Menezes <menezesbr@gmail.com>

# set some environment variables
ENV APP_NAME app
ENV APP_EMAIL app@empresa.com
ENV APP_DOMAIN app.dev
ENV DEBIAN_FRONTEND noninteractive

# upgrade the container
RUN apt-get update && \
    apt-get upgrade -y

# install some prerequisites
RUN apt-get install -y software-properties-common 
RUN apt-get install -y curl 
RUN apt-get install -y build-essential
RUN apt-get install -y dos2unix 
RUN apt-get install -y gcc 
RUN apt-get install -y git 
RUN apt-get install -y libmcrypt4 
RUN apt-get install -y libpcre3-dev 
RUN apt-get install -y memcached 
RUN apt-get install -y make 
RUN apt-get install -y python2.7-dev 
RUN apt-get install -y python-pip 
RUN apt-get install -y re2c 
RUN apt-get install -y unattended-upgrades 
RUN apt-get install -y whois 
RUN apt-get install -y vim 
RUN apt-get install -y libnotify-bin 
RUN apt-get install -y nano 
RUN apt-get install -y wget 
RUN apt-get install -y debconf-utils 
RUN apt-get install -y python-software-properties 
RUN apt-get install -y zip 
RUN apt-get install -y unzip 
RUN apt-get install -y p7zip-full  

# add some repositories
RUN apt-add-repository ppa:nginx/stable -y  
RUN apt-add-repository ppa:chris-lea/redis-server -y     
RUN curl -s https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    curl --silent --location https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update

# setup bash
COPY .bash_aliases /root

# install sqlite 
RUN apt-get install --force-yes -y sqlite3 libsqlite3-dev  
 
# install nodejs
RUN apt-get install -y nodejs

# install gulp
RUN /usr/bin/npm install -g gulp

# install bower
RUN /usr/bin/npm install -g bower    

RUN apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor

# upgrade the container
RUN apt-get update -y
RUN apt-get upgrade -y    

# install nginx
RUN apt-get install --force-yes -y nginx

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
VOLUME ["/etc/nginx/sites-available"]

# install php 7
RUN apt-get install -y --force-yes php7.1 php7.1-gmp php7.1-bcmath php7.1-intl php7.1-curl \
    php7.1-xml php7.1-soap php7.1-fpm php7.1-cli php7.1-common php7.1-mbstring php7.1-gd  \
    php7.1-xml php7.1-mysql php7.1-mcrypt php7.1-zip   

RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini && \
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

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc

# install redis 
RUN apt-get install -y redis-server

# install blackfire
RUN apt-get install -y blackfire-agent blackfire-php

# install beanstalkd
RUN apt-get install -y --force-yes beanstalkd && \
    sed -i "s/BEANSTALKD_LISTEN_ADDR.*/BEANSTALKD_LISTEN_ADDR=0.0.0.0/" /etc/default/beanstalkd && \
    sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd && \
    /etc/init.d/beanstalkd start

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

# expose ports
EXPOSE 80 443 6379

# set container entrypoints
ENTRYPOINT ["/bin/bash","-c"]
CMD ["/usr/bin/supervisord"]
    