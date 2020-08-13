#!/bin/bash

# install dependencies
apt-get -y update && \
apt-get install -y \
  build-essential \
  apache2-dev \
  libxml2-dev

# download PHP 5.5.30 source code
cd /tmp
curl -fsSL http://php.net/get/php-5.5.30.tar.bz2/from/this/mirror | tar xjf -
cd php-5.5.30

# configure build options
./configure --prefix=/usr \
            --with-config-file-path=/etc/php5/apache2 \
            --with-config-file-scan-dir=/etc/php5/apache2/conf.d \
            --disable-pdo \
            --disable-json \
            --enable-mbstring \
            --with-apxs2

# compile and install
NUM_CORES=`cat /proc/cpuinfo | grep processor | wc -l`
make -j $NUM_CORES
make install

# configure extension directory
echo 'extension_dir="/usr/lib/php5/20121212"' >> /etc/php5/apache2/php.ini

# cleanup
rm -rf /tmp/php-5.5.30 /tmp/install_php-5.5.30.sh