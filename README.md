### Serviores para docker

# u14.04a
**Versão do Ubuntu 14.04 atualizado em 02/04/2018 - preparado para funcionar Apache 2 e PHP **
`Repositories`
  ```
    apt-add-repository ppa:ondrej/php -y && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y && \  
    curl -s https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    curl --silent --location https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update
  ``` 

`Pacotes instalados`
- [x] SQLite
- [x] NodeJS 8
- [x] Bower
- [x] Gulp
- [x] Supervisor



# u14.04n
**Versão do Ubuntu 14.04 atualizado em 02/04/2018 - preparado para funcionar Apache 2 e PHP **
`Repositories`
  ```
    apt-add-repository ppa:nginx/stable -y  && \
    apt-add-repository ppa:chris-lea/redis-server -y && \
    apt-add-repository ppa:ondrej/php -y && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y && \  
    curl -s https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    curl --silent --location https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update
  ``` 

`Pacotes instalados`
- [x] SQLite
- [x] NodeJS 8
- [x] Bower
- [x] Gulp
- [x] Supervisor


# n7l
**Versão com u14.04n preparado para Laravel**

`Pacotes instalados`
- [x] Nginx 1.8.1
- [x] PHP 5.6 & 7.0 & 7.1
- [x] Redis
- [x] Beanstalkd
- [x] Blackfire
- [x] Composer
- [x] Laravel Envoy
- [x] Laravel Installer 5.6

**Aponte o volume** `/var/www/html/app` **para seu diretório da aplicação local**



# a5.6
**Versão com u14.04a preparado com Apache**

`Pacotes instalados`
- [x] Apache 2
- [x] PHP 5.6
- [x] Composer

**Aponte o volume** `/var/www/html` **para seu diretório da aplicação local**



# lampp56
**Server com debian:jessie utilizando LAMPP x64 com PHP versão 5.6 -> xampp-linux-x64-5.6.21-0-installer.run**

**Aponte o volume** `/opt/lampp/htdocs/` **para seu diretório da aplicação local**


# lampp70
**Server com debian:jessie utilizando LAMPP x64 com PHP versão 7.0 -> xampp-linux-x64-7.0.25-0-installer.run**

**Aponte o volume** `/opt/lampp/htdocs/` **para seu diretório da aplicação local**
