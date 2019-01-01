#!/bin/bash
echo "removing previously existing webroot directory"
rm -rf ./webroot && mkdir ./webroot

docker build -t dhl-experimental .

echo "copying files over..."
docker run --rm dhl-experimental tar -cC /var/www/html . | tar -xC ./webroot
echo "file transfer completed!"

if [ "$1" == "--start" ]; then
  echo "Starting docker-headless-lightning development orchestration"
  docker-compose up --build -d
fi
