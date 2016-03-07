#!/bin/bash

if [ ! -z "${TIMEZONE}" ]
then
   rm -f /etc/localtime
   ln -sf /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime
fi

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -D FOREGROUND
