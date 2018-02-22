#!/bin/bash

[ -z "$TZ" ] && { TZ="UTC"; }
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

java -jar /opt/unimus.jar
