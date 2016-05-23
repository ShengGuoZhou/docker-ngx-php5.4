# Set the base image to Ubuntu
FROM centos:6.7

# File Author / Maintainer
MAINTAINER Daniel Meneses <danielmeneses.pt@gmail.com>

# Add the ngix and PHP dependent repository
ADD nginx.repo /etc/yum.repos.d/nginx.repo

# Installing nginx
RUN yum -y install nginx

# Installing PHP
RUN yum -y --enablerepo=remi,remi-php54 install nginx \
    php-fpm \
    php-common \
    # for xdebug next
    php-devel php-pear gcc gcc-c++ autoconf automake \
    memcached \
    mysql-server \
    php-mysql \
    php-pecl-memcache \
    php-soap \
    php-gd \
    php-mbstring \
    php-apc \
    php-mcrypt \
    php-dom

# Set timezone php.ini
RUN echo ​"date.timezone = Europe/London" >> /etc/php.ini

# Install Redis
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum --enablerepo=remi,remi-test install redis php-redis -y

# Install xdebug and ativate it
RUN pecl install Xdebug -y
RUN printf "\n[xdebug]\nzend_extension='/usr/lib64/php/modules/xdebug.so'\nxdebug.remote_enable = 1" >> /etc/php.ini
RUN touch /etc/php.d/xdebug.ini
RUN echo xdebug.remote_enable=1 >> /etc/php.d/xdebug.ini; \
    echo xdebug.remote_handler=dbgp >> /etc/php.d/xdebug.ini; \
    echo xdebug.remote_autostart=1 >> /etc/php.d/xdebug.ini; \
    echo xdebug.remote_connect_back=1 >> /etc/php.d/xdebug.ini; \
    echo xdebug.remote_host=172.17.0.1 >> /etc/php.d/xdebug.ini; \
    echo xdebug.remote_port=3000 >> /etc/php.d/xdebug.ini; \
    echo xdebug.idekey="netbeans-xdebug" >> /etc/php.d/xdebug.ini; \
    echo xdebug.remote_log="/container-scripts/xdebug.log" >> /etc/php.d/xdebug.ini;

# Installing supervisor
RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install supervisor

# perform cleanup
RUN yum clean all -y
RUN rm -rf /var/cache/yum/x86_64/6/*

# Adding the configuration file of the nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf

# Adding the configuration file of the Supervisor
ADD supervisord.conf /etc/

# Add start shell script
ADD start2.1.sh /container-scripts/

# Set the port to 80 and 3000 for xdebug
EXPOSE 80

# Executing supervisord
CMD ["sh", "/container-scripts/start2.1.sh"]
