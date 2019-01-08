#!/bin/bash

while ! nc -z mariadb 3306; do
    sleep 1
    echo "Waiting for MariaDB intialization, retrying in (1) second..."
done
