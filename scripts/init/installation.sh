#!/bin/bash
set -e

docker-compose down

echo "removing previously existing webroot and database directory"
sudo chown `whoami`:`whoami` -R ./
sudo rm -rf ./webroot ./database && mkdir ./webroot

echo "building fresh dhl-experimental && copying files over..."
docker build -t dhl-experimental . && docker run --rm dhl-experimental tar -cC /var/www/html . | tar -xC ./webroot
echo "file transfer completed!"

if [ "$1" == "--start" ]; then
  echo "Starting docker-headless-lightning development orchestration"
  docker-compose up --build
fi

if [ "$1" == "--startd" ]; then
  echo "Starting docker-headless-lightning development orchestration"
  docker-compose up --build -d

  if [ "$2" == "--drush-si" ]; then
    source ./mysql.env
    source ./drupal.env

    docker-compose exec headless-lightning /opt/scripts/wait-until-mariadb-init.sh

    docker-compose exec headless-lightning ./vendor/bin/drush site:install \
     --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@mariadb/$MYSQL_DATABASE" \
     --account-mail="$ACCOUNT_MAIL" \
     --site-mail="$SITE_MAIL" \
     --site-name="$SITE_NAME" \
     --yes

     sudo chmod 777 webroot/docroot/sites/default/settings.php
     cat install.settings.php >> webroot/docroot/sites/default/settings.php
     cat database.settings.php >> webroot/docroot/sites/default/settings.php
     sudo chmod 444 webroot/docroot/sites/default/settings.php

     docker-compose exec headless-lightning chown -R www-data:www-data /var/www/html
  fi
fi
