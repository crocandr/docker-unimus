FROM archlinux:20200407

ENV DOWNLOAD_URL https://unimus.net/download-unimus/dev-builds/Unimus.jar

#RUN apt-get update && apt-get install -y curl vim less wget tzdata
RUN pacman -Sy --noconfirm curl tzdata

# OpenJDK
# 13.02
#RUN pacman -S --noconfirm jre-openjdk-headless
# 11.06
#RUN pacman -S --noconfirm jre11-openjdk-headless
# 8
RUN pacman -S --noconfirm jre8-openjdk-headless

#
# Unimus 
RUN curl -L -o /opt/unimus.jar $DOWNLOAD_URL
#
# Start script
COPY files/start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh
#
ENTRYPOINT /opt/start.sh

