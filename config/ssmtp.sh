#!/bin/bash

echo "Setup ssmtp"

CONF=/etc/ssmtp/ssmtp.conf
rm $CONF
ENABLE_SSMTP=false

for E in $(env)
do
  if [ "$(echo $E | sed -e '/^SSMTP_/!d' )" ]
  then
    echo $E | sed -e 's/^SSMTP_//' >> $CONF
    ENABLE_SSMTP=true
  fi
done

if [ $ENABLE_SSMTP ]; then
  echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini
fi 

exec "$@"
