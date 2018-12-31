#!/bin/bash
source ./mysql.env

docker-compose exec mariadb mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > export.sql
