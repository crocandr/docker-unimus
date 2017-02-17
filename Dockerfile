FROM ubuntu:xenial

RUN apt-get update && apt-get install -y curl vim less wget
# OpenJDK
RUN apt-get install -y openjdk-8-jre-headless
# Oracle JDK
#RUN curl -L --header "Cookie: oraclelicense=accept-securebackup-cookie" -o /opt/jdk.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz && tar xzf /opt/jdk.tar.gz -C /opt && ln -s /opt/jdk1* /opt/java && ln -s /opt/java/bin/java /usr/local/bin
# Latest version
#RUN curl -L -o /opt/unimus.jar https://unimus.net/download/-%20Latest/Unimus.jar
# Specified version
RUN curl -L -o /opt/unimus.jar https://unimus.net/download/0.2.3/Unimus.jar

COPY files/start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh

