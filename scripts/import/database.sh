#!/bin/bash
source ./mysql.env

docker-compose exec mariadb mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < ${1}

docker-compose restart mariadb
