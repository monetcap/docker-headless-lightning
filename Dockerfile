FROM drupal:8.6.4-apache

LABEL maintainer="kaden@vermilion.tech"
LABEL version="pre-alpha"
LABEL description="a headless-lightning docker orchestration"

# install headless-lightning
RUN apt-get update && apt-get install --no-install-recommends -yq \
 git \
 mysql-client \
 && rm -rf /var/lib/apt/lists/*

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN composer global require hirak/prestissimo

# clean web root
RUN rm -rf /var/www/html

RUN composer create-project acquia/lightning-project:dev-headless --no-interaction --stability dev .

RUN composer require drush/drush

RUN mv README.md HEADLESS-LIGHTNING.md

COPY ./000-default.conf /etc/apache2/sites-available

COPY docker-entrypoint.sh /bin
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]
