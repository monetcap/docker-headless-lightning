#!/bin/bash
set -e

docker-compose down

echo "removing previously existing webroot and database directory"
sudo chown -R `whoami`:`id -gn` ./
sudo rm -rf ./webroot ./database && mkdir ./webroot

echo "building fresh dhl-experimental && copying files over..."
docker build -t dhl-experimental . && docker run --rm dhl-experimental tar -cC /var/www/html . | tar -xC ./webroot
echo "file transfer completed!"

echo "composing orchestration..."
docker-compose up --build -d

echo "sourcing environment files..."
source ./mysql.env
source ./drupal.env

echo "waiting until mariadb inits..."
docker-compose exec headless-lightning /opt/scripts/wait-until-mariadb-init.sh

echo "installing site w/ drush..."
docker-compose exec headless-lightning ./vendor/bin/drush site:install \
 --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@mariadb/$MYSQL_DATABASE" \
 --account-mail="$ACCOUNT_MAIL" \
 --site-mail="$SITE_MAIL" \
 --site-name="$SITE_NAME" \
 --yes

echo "initializing webroot/docroot/sites/default/settings.php"
 sudo chmod 777 webroot/docroot/sites/default/settings.php
 sudo sed -i -e "s/^\s*'database' => .*,/    'database' => getenv('MYSQL_DATABASE'),/g" webroot/docroot/sites/default/settings.php
 sudo sed -i -e "s/^\s*'username' => .*,/    'username' => getenv('MYSQL_USER'),/g" webroot/docroot/sites/default/settings.php
 sudo sed -i -e "s/^\s*'password' => .*,/    'password' => getenv('MYSQL_PASSWORD'),/g" webroot/docroot/sites/default/settings.php
 sudo sed -i -e "s/^\s*'host' => .*,/    'host' => getenv('MYSQL_HOST'),/g" webroot/docroot/sites/default/settings.php
 sudo sed -i -e "s/^\s*'port' => .*,/    'port' => getenv('MYSQL_PORT'),/g" webroot/docroot/sites/default/settings.php
 sudo chmod 444 webroot/docroot/sites/default/settings.php

echo "ensuring directory permissions match www-data:www-data"
 docker-compose exec headless-lightning chown -R www-data:www-data /var/www/html

echo "rebuilding drupal cache"
 docker-compose exec headless-lightning ./vendor/bin/drush cr
