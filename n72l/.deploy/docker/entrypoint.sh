#!/bin/bash

# make sure the correct directories exists (suggested by @chrif):
mkdir -p $_PATH/storage/app
mkdir -p $_PATH/storage/app/public
mkdir -p $_PATH/storage/build
mkdir -p $_PATH/storage/database
mkdir -p $_PATH/storage/debugbar
mkdir -p $_PATH/storage/export
mkdir -p $_PATH/storage/framework/cache
mkdir -p $_PATH/storage/framework/sessions
mkdir -p $_PATH/storage/framework/testing
mkdir -p $_PATH/storage/framework/views
mkdir -p $_PATH/storage/logs
mkdir -p $_PATH/storage/upload


# make sure we own the volumes:
chown -R www-data:www-data -R $_PATH/storage
chmod -R 775 $_PATH/storage

# remove any lingering files that may break upgrades:
rm -f $_PATH/storage/logs/laravel.log

cat .env.docker | envsubst > .env
composer dump-autoload
php artisan package:discover
php artisan firefly:instructions install
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon