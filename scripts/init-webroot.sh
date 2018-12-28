#!/bin/bash
docker build -t dhl-experimental . && docker run --rm dhl-experimental tar -cC /var/www/html . | tar -xC ./
