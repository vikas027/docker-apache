#!/bin/bash
## Set password if passed as environment variable
if [ ! -z "${ROOT_PASS}" ]
then
   echo "root:${ROOT_PASS}" | chpasswd
fi

## Set password if passed as environment variable
if [ ! -z "${TIMEZONE}" ]
then
   rm -f /etc/localtime
   ln -sf /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime
fi

/usr/sbin/sshd -D
