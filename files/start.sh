#!/bin/bash

JAVA_EXTRA_PARAMS=""

[ ! -z "$XMS" ] &&  { JAVA_EXTRA_PARAMS="$JAVA_EXTRA_PARAMS -Xms$XMS"; }
[ ! -z "$XMX" ] && { JAVA_EXTRA_PARAMS="$JAVA_EXTRA_PARAMS -Xmx$XMX"; }
[ ! -z "$JAVA_OPTS" ] && { JAVA_EXTRA_PARAMS="$JAVA_OPTS"; }

#[ -z "$TZ" ] && { TZ="UTC"; }
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# verify jar
if [ $( which jarsigner | wc -l ) -gt 0 ]
then
  jarsigner -verify /opt/unimus.jar | grep -i "jar verified" || { echo "Unimus binary is not verified"; exit 1; }
fi

# run
java $JAVA_EXTRA_PARAMS -jar /opt/unimus.jar
