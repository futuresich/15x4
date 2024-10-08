15x4
====

15x4 is community running free popular science lectures in CIS and Europe. More at [15x4.org](15x4.org)

## How to run with Docker

- Clone the repo.
- Fill `app/config/parameters.yml` by example.
- Run `docker compose up -d` and it will do the job! The app will listen on port 8080.
- To install required dependencies, do `composer install` in the container.

### How to run locally - old instructions

After cloning project from git, you need to install [composer package manager](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx)

To install required dependencies, do `composer install`

To configure local instance, do `cp app/config/parameters.yml.dist app/config/parameters.yml`. You may want to edit `app/config/parameters.yml` afterwards, especially DB connection credentials.

To build project itself, do
```
bin/console doctrine:database:create
bin/console doctrine:schema:update --force
bin/console 15x4:load-fields
bin/console assets:install --symlink
bin/console assetic:dump --env=prod --no-debug
```
To run application as a site, you need a webserver. You may use whatever you like, but production uses Apache2.

Simplest option is Symfony built-in server, though it has some known issues:
```
bin/console server:run --env=prod
```
