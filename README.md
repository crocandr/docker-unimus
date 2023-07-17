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
You can use HSQL (local - file-based) or MySQL (with an other container) for the backend DB.

You can run the unimus with 2 method:
  - with `docker run ...` command
  - with `docker-compose` (recommended way)

### with HSQL

```
docker run -tid --name=unimus -p 8085:8085 -v /srv/unimus/config:/etc/unimus/ croc/unimus
```

Configuration and HSQL databases files is in `/etc/unimus` folder in the container.

### with MySQL

Start your MySQL container for Unimus:

```
docker run -tid --name=unimus-db -v /srv/unimus/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=supersecret -e MYSQL_DATABASE=unimus -e MYSQL_USER=unimus -e MYSQL_PASSWORD=secret mariadb
```

Start your Unimus:

```
docker run -tid --name=unimus -p 8085:8085 -v /srv/unimus/config:/etc/unimus/ --link=unimus-db:db croc/unimus
```

You have to use these parameters with Unimus' MySQL config:
  - db host: `db` (if you've started with docker-compose, use the name of the database container `unimus-db`)
  - db: `unimus`
  - db user: `unimus`
  - db pass: `secret`

Good for a test, but not too secure.

## Docker compose

I've written a `docker-compose.yml` file for easier start with the database. This is the recommended method.

Start:
```
docker-compose up -d
```

...and that's it :)


Check the docker-compose file for extra parameters!

### Specify a version

How to use a specified version with docker-compose file? <br />
Add the version tag to the unimus image line. <br />
Example:
```
image: croc/unimus:v2.1.0
```

Sorry, you can't build an image with an older unimus version, because I don't know the download URL for an older version. So I've built the docker image for the latest binary when it was an older version. <br />
I recommend use the latest version, always.

## Usage

Default Unimus' URL is http://< your docker host>:8085 , example: http://192.168.56.103:8085

You have to configure your Unimus after the first start on this URL.

You have to register on https://unimus.net/ for license keys.

## Update

If you want to update unimus with this "stack":
  - stop all containers ( example: `docker stop unimus unimus-db` or `docker-compose stop` )
  - remove all containers ( example: `docker rm -v unimus unimus-db` or `docker-compose rm -v -f` )
  - pull new images ( example: `docker pull croc/unimus` and `docker pull mariadb` or remove images to pull new `docker rmi croc/unimus mariadb` )
  - start the stack again


## More config options

Check the official documentation for more options.

  - https://wiki.unimus.net/display/UNPUB/Initial+configuration

### Behind a proxy

Check these pages:
  - https://wiki.unimus.net/display/UNPUB/Running+Unimus+behind+a+HTTP%28S%29+proxy
  - https://github.com/crocandr/docker-unimus/issues/14

Add the some extra parameters into the docker-compose file for the proxy connection. Example:
```
- JAVA_OPTS=-Xms256M -Xmx1024M -Dhttp.proxyHost=1.1.1.1 -Dhttp.proxyPort=8080 -Dhttps.proxyHost=2.2.2.2 -Dhttps.proxyPort=8443
```



Good luck! Have fun!
