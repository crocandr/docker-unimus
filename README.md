# Unimus in Docker

Unimus is a multi-vendor network device configuration backup and management solution, designed from the ground up with user friendliness, workflow optimization and ease-of-use in mind.

  - https://unimus.net/
  - https://wiki.unimus.net/display/UNPUB/Running+in+Docker

## Build

```
docker build -t croc/unimus .
```

## Run

You've to have a DB for the Unimus.
You can use HSQL (local - file based) or MySQL (with an other container) for the backend DB.

### with HSQL

```
docker run -tid --name=unimus -p 8085:8085 -e /srv/unimus/config:/etc/unimus/ -v /srv/unimus/db:/var/unimus/hsql croc/unimus /opt/start.sh
```

### with MySQL

Start your MySQL container for Unimus:

```
docker run -tid --name=unimus-db -v /srv/unimus/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=supersecret -e MYSQL_DATABASE=unimus -e MYSQL_USER=unimus -e MYSQL_PASSWORD=secret mariadb
```

Start your Unimus:

```
docker run -tid --name=unimus -p 8085:8085 -v /srv/unimus/config:/etc/unimus/ --link=unimus-db:db croc/unimus /opt/start.sh
```

You have to use these parameters with Unimus' MySQL config:
  - db host: `db` (if you've started with docker-compose, use the name of the database container `unimus-db`)
  - db: `unimus`
  - db user: `unimus`
  - db pass: `secret`

Good for a test, but not too secure.

## Docker compose

I've written a `docker-compose.yml` file for easier start with database.

Start:
```
docker-compose up -d
```

...and that's it :)

## Usage

Default Unimus' URL is http://< your docker host>:8085 , example: http://192.168.56.103:8085

You have to configure your Unimus after the first start on this URL.

You have to register on https://unimus.net/ for license keys.

## Update

If you want to update unimus with this "stack".
  - stop all containers ( example: `docker stop unimus unimus-db` or `docker-compose stop` )
  - remove all containers ( example: `docker rm -v unimus unimus-db` or `docker-compose rm -v -f` )
  - pull new images ( example: `docker pull croc/unimus` and `docker pull mariadb` or remove images to pull new `docker rmi croc/unimus mariadb` )
  - start the stack again 


Good luck!
