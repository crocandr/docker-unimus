#
# JDK - JAR checksum
#
FROM debian:bullseye AS build

ENV DOWNLOAD_URL https://download.unimus.net/unimus/-%20Latest/Unimus.jar

RUN apt-get update && apt-get install -y curl less wget tzdata iproute2 procps

#
# Unimus
RUN curl -L -o /opt/unimus.jar $DOWNLOAD_URL

# JDK install and check
RUN apt-get install -y openjdk-11-jdk-headless && \
    jarsigner -verify /opt/unimus.jar | grep -i "jar verified" || { echo "Unimus binary is not verified"; exit 1; } && \
    sha1sum /opt/unimus.jar > /tmp/checksum.txt && \ 
    apt-get purge -y openjdk-11-jdk-headless

#
# Build JRE based container
#
FROM debian:bullseye

RUN apt-get update && apt-get install -y curl less wget tzdata iproute2 procps

COPY --from=build /opt/unimus.jar /opt/unimus.jar
COPY --from=build /tmp/checksum.txt /tmp/checksum-original.txt 

# checksum test
RUN sha1sum /opt/unimus.jar > /tmp/checksum.txt && \
    [ $( diff -q /tmp/checksum.txt /tmp/checksum-original.txt | wc -l ) -eq 0 ] || {  echo "Jar file problem - not signed or checksum different" ; exit 1; }

# JRE install
RUN apt-get install -y openjdk-11-jre-headless && \
    echo "Verified checksum: $CHECKSUM"

# user
RUN groupadd -g 10000 appgroup && \
    useradd -s /bin/bash -m -g appgroup -u 10000 appuser

RUN mkdir /etc/unimus && \
    chown appuser:appgroup /etc/unimus && \ 
    chmod 775 /etc/unimus
RUN mkdir /var/log/unimus && \
    chown appuser:appgroup /var/log/unimus && \
    chmod 775 /var/log/unimus
#
# Start script
COPY files/start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh
#
USER appuser 
#
ENTRYPOINT /opt/start.sh
