#!/bin/bash
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

function prompt_proper_configuration {
  read -p "Please verify that you've properly configured mysql.env, drupal.env, and default.settings.php... [y/n]" -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      echo "Exiting...!"
      exit 1
  fi
}

function exists_mysql_env {
  if [ ! -f ./mysql.env ]; then
    echo "[ERROR]: ./mysql.env file doesn't exist..."
    exit 1
  fi
}

function exists_drupal_env {
  if [ ! -f ./drupal.env ]; then
    echo "[ERROR]: ./drupal.env file doesn't exist..."
    exit 1
  fi
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -ec|--export-config)
      docker-compose exec -T headless-lightning ./vendor/bin/drush cex --yes
      shift # past argument
    ;;
    -edb|--export-database)
      exists_mysql_env

      EXPORT_PATH="$2"

      source ./mysql.env
      docker-compose exec -T mariadb mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > "$EXPORT_PATH"
      shift # past argument
      shift # past value
      ;;
    -ic|--import-config)
      docker-compose exec -T headless-lightning ./vendor/bin/drush cim --yes
      docker-compose exec -T headless-lightning ./vendor/bin/drush cr
      shift # past argument
    ;;
    -idb|--import-database)
      exists_mysql_env

      IMPORT_PATH="$2"
      source ./mysql.env
      docker-compose exec -T mariadb mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < "$IMPORT_PATH"
      docker-compose exec -T headless-lightning ./vendor/bin/drush cr
      docker-compose restart mariadb

      shift # past argument
      shift # past value
    ;;
    -is|--import-site)
      exists_mysql_env
      exists_drupal_env

      IMPORT_PATH="$2"
      source ./mysql.env

      docker-compose up --build -d

      docker-compose exec -T headless-lightning /opt/scripts/wait-until-mariadb-init.sh
      docker-compose exec -T mariadb mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < "$IMPORT_PATH"
      docker-compose restart mariadb
      docker-compose exec -T headless-lightning ./vendor/bin/drush cr

      docker-compose exec -T headless-lightning ./vendor/bin/drush cim --yes
      docker-compose exec -T headless-lightning ./vendor/bin/drush cr

      shift # past argument
      shift # past value
    ;;
    --install)
      exists_mysql_env
      exists_drupal_env

      prompt_proper_configuration

      bash ./scripts/installation.sh
      shift # past argument
    ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
