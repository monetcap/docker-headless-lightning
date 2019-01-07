#!/bin/bash
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -ec|--export-config)
      docker-compose exec headless-lightning ./vendor/bin/drush cex --yes
      shift # past argument
    ;;
    -edb|--export-database)
      EXPORT_PATH="$2"

      source ./mysql.env
      docker-compose exec mariadb mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > "$EXPORT_PATH"
      shift # past argument
      shift # past value
      ;;
    -ic|--import-config)
      docker-compose exec headless-lightning ./vendor/bin/drush cim --yes
      shift # past argument
    ;;
    -idb|--import-database)
      IMPORT_PATH="$2"
      source ./mysql.env
      docker-compose exec mariadb mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < "$IMPORT_PATH"
      docker-compose restart mariadb

      shift # past argument
      shift # past value
    ;;
    --install)
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
