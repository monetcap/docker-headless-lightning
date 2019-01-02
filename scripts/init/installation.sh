#!/bin/bash
docker-compose down

echo "removing previously existing webroot and database directory"
sudo rm -rf ./webroot ./database && mkdir ./webroot

echo "copying files over..."
docker run --rm dhl-experimental tar -cC /var/www/html . | tar -xC ./webroot
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
  fi
fi
