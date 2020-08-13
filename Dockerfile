FROM php:5.6-apache
#FROM ubuntu:trusty

VOLUME ["/var/www"]

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    apt-get install -y \
      apache2 \
      curl \
      libcurl3 \
      libcurl3-dev \
      php5 \
      php5-cli \
      libapache2-mod-php5 \
      php5-gd \
      php5-json \
      php5-ldap \
      php5-mysqlnd \
      php5-pgsql \
      php5-curl \
      mysql-client

COPY config/php.ini /etc/php5/apache2/php.ini

# install php-5.5.30
COPY config/install_php-5.5.30.sh /tmp/install_php-5.5.30.sh
RUN /bin/bash /tmp/install_php-5.5.30.sh


COPY config/apache_default.conf /etc/apache2/sites-available/000-default.conf
COPY config/run /usr/local/bin/run

RUN chmod +x /usr/local/bin/run
RUN a2enmod rewrite

# Copy hello-cron file to the cron.d directory
COPY hello-cron /etc/cron.d/hello-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log

#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server python-mysqldb

ENV MYSQL_USER=admin \
    MYSQL_PASS= \
    REPLICATION_USER=replica \
    REPLICATION_PASS=replica \
    REPLICATION_HOST= \
    REPLICATION_PORT=3306 \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_CONFIG=/etc/mysql/conf.d/custom.cnf \
    MYSQL_RUN_DIR=/var/run/mysqld \
    MYSQL_LOG=/var/log/mysql/error.log \
    OS_LOCALE="en_US.UTF-8"

# Set the locale
RUN locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
    LANGUAGE=en_US:en \
    LC_ALL=${OS_LOCALE}

# Add MySQL configuration
COPY config/custom.cnf ${MYSQL_CONFIG}

RUN apt-get update \
    && apt-get -yq install mysql-server-5.5 mysql-client-5.5 lbzip2 \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/mysql/conf.d/mysqld_safe_syslog.cnf \
    && touch /tmp/.EMPTY_DB \
    # Forward request and error logs to docker log collector
    && ln -sf /dev/stderr ${MYSQL_LOG}

EXPOSE 3306/tcp
EXPOSE 80/tcp

COPY config/entrypoint.sh /sbin/entrypoint.sh
COPY config/test.sh /test.sh
copy bnt/* /var/www/html/bnt/

RUN chmod 755 /sbin/entrypoint.sh
RUN chmod 755 /test.sh

CMD ["/bin/bash", "/test.sh", "apache2-foreground"]
CMD ["/usr/local/bin/run"]

VOLUME  ["${MYSQL_DATA_DIR}", "${MYSQL_RUN_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
