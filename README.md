# glpi-docker

Dockerized glpi environment

Contains:

- [GLPI 9.5.6](https://github.com/glpi-project/glpi)
- [PHP 7.4](https://hub.docker.com/_/php)
- [MySQL 5.7.36](https://hub.docker.com/_/mysql)
- [Adminer](https://hub.docker.com/_/adminer)

## Instructions
1. Launch compose in daemon mode with `docker-compose up -d`
2. Browse to http://localhost:8080
3. Select "Upgrade" during setup
4. Input database credentials (check docker-compose.yml)
5. Enter glpi container with `docker exec -it glpi bash`
6. Run in bash `bin/console glpi:migration:timestamps`
7. Fix permissions with `chown -R www-data:www-data .`
8. Exit container with `exit`
9. Reload containers with `docker-compose restart`
10. Stop compose with `docker-compose down`

To do a full clean up remove volumes with `docker-compose down -v`

## Browse database
1. Browse to http://localhost:9000
2. Enjoy!