FROM debian:latest

ENV DOWNLOAD_URL https://unimus.net/download-unimus/dev-builds/Unimus.jar

RUN apt-get update && apt-get install -y curl less wget tzdata iputils-ping

# copy all files into the container image
COPY files/* /opt/

# Unimus binary download
RUN curl -L -o /opt/unimus.jar $DOWNLOAD_URL
# check the downloaded file if checksum exists
RUN if [ -f /opt/checksum.signed ]; then echo "Checking checksum..."; sha1sum /opt/unimus.jar > /opt/checksum.new; sed -i "s@/opt/@@g" /opt/checksum.new; cat /opt/checksum*; diff -q /opt/checksum.new /opt/checksum.signed || { echo "Checksum invalid"; exit 1; }; fi

# JRE instal
RUN apt-get install -y openjdk-17-jre-headless

#
# Start script permission
RUN chmod 755 /opt/start.sh
#
ENTRYPOINT /opt/start.sh
