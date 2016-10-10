# Unimus in Docker

## Build

```
docker build croc/unimus .
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
docker run -tid --name=unimus -p 8085:8085 -e /srv/unimus/config:/etc/unimus/ --link=unimus-db:db croc/unimus /opt/start.sh
```

You have to use the `db` as `Host` at the Unimus' MySQL config.

## Usage

You can access the Unimus' URL on http://< your docker host>:8085 , example: http://192.168.56.103:8085

You have to configure your Unimus after the first start on this URL.

You have to register on https://unimus.net/ for license keys.




Good luck!
