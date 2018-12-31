#!/bin/bash
echo "fixing /var/www/html permissions..."
chown -R www:data:www-data /var/www/html

echo "starting apache server for headless-lighning"
apache2-foreground
