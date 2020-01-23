FROM debian:buster

ENV DOWNLOAD_URL https://unimus.net/download/dev-builds/Unimus.jar

RUN apt-get update && apt-get install -y curl vim less wget tzdata

# OpenJDK
RUN apt-get install -y openjdk-11-jre-headless
#
# Unimus 
RUN curl -L -o /opt/unimus.jar $DOWNLOAD_URL
#
# Start script
COPY files/start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh
#
ENTRYPOINT /opt/start.sh

