# docker-headless-lightning

1. Clone the `docker-headless-lightning` repository
`git clone git@github.com:vermilion-tech/docker-headless-lightning.git`

### Initial Installation
Before you proceed, please read the `configuration` section of this `README`

If you don't already have a `docker-headless-lightning` installation, you can initialize one using
`./scripts/main.sh --install`

After this you may want to comment out the `webroot` entry in `.gitignore` to include your webroot with the repository!

### Cloning the site to make a development environment or etc.
Before you proceed, please read the `configuration` section of this `README`

You will need to have `mysql.env`, `drupal.env`, and `default.settings.php` all match the values configured on the production server or else you will encounter errors during installation/runtime

You will also need to have a database dump from the production server to initially seed your environment. We provide an easy command for this `./scripts/main.sh --export-database /path/to/export/file/to`

Once you have configured and retrieved all of the necessary files, run `./scripts/main.sh --import-site /path/to/export/file`

### Configuration

###### drupal.env
Use this file to customize settings that Drupal will use on site initialization, using `./scripts/main.sh --install`
```
ACCOUNT_MAIL=admin@prod-backend.monetcap.com
SITE_MAIL=admin@prod-backend.monetcap.com
SITE_NAME=prod-backend.monetcap.com
```

###### mysql.env
Use this file to customize the settings that Drupal will use to connect to its database, we recommend changing `MYSQL_USER` and `MYSQL_PASSWORD`, and maybe even `MYSQL_DATABASE`, in production.

We only support databases hosted within the `docker-compose` orchestration, using the `mariadb` service. Support for non `docker-compose` MySQL service will be supported in later release.

```
MYSQL_DATABASE=drupal

MYSQL_USER=drupal_user
MYSQL_PASSWORD=supersecret

MYSQL_ROOT_PASSWORD=secret
MYSQL_RANDOM_ROOT_PASSWORD=yes

MYSQL_PORT=3306
MYSQL_HOST=mariadb
```

###### default.settings.php
This file is used to initialize the `default.settings.php` on image build before site initialization, using `./scripts/main.sh --install`

In order to properly setup `trusted_host_patterns`, you must change the `example.com` entries to match your FQDN.

For the other options, we recommend leaving them alone unless you know what you are doing.
```
if (file_exists('/environment/mysql.env')) {
    // Load environment
    $dotenv = Dotenv\Dotenv::create('/environment', 'mysql.env');
    $dotenv->load();
}

$config_directories[CONFIG_SYNC_DIRECTORY] = "../config";

$settings['trusted_host_patterns'] = array(
    '^example\.com$',
    '^.+\.example\.com$',
    '^127\.0\.0\.1$',
    '^localhost$',
);
```
