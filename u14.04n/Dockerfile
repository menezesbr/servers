FROM ubuntu:14.04
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
RUN apt-get install -y software-properties-common curl build-essential \
    dos2unix gcc git libmcrypt4 libpcre3-dev memcached make python2.7-dev \
    python-pip re2c unattended-upgrades whois vim libnotify-bin nano wget \
    debconf-utils python-software-properties software-properties-common nano zip unzip p7zip-full   

 # add some repositories
RUN apt-add-repository ppa:nginx/stable -y 
RUN apt-add-repository ppa:ondrej/php -y 
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5 
RUN sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" >> /etc/apt/sources.list.d/mysql.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list' && \
    curl -s https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    curl --silent --location https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update

#RUN apt-add-repository ppa:nginx/stable -y  && \
#    apt-add-repository ppa:chris-lea/redis-server -y && \
#    apt-add-repository ppa:ondrej/php -y && \
#    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y && \  
#    curl -s https://packagecloud.io/gpg.key | apt-key add - && \
#    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
#    curl --silent --location https://deb.nodesource.com/setup_8.x | bash - && \
#    apt-get update

# set the locale
RUN echo "LC_ALL=pt_BR.UTF-8" >> /etc/default/locale  && \
    locale-gen pt_BR.UTF-8  && \
    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime  
    
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

# install supervisor
RUN apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor

RUN apt-get install -y nano zip unzip p7zip-full      