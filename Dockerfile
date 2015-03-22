FROM ubuntu:15.04
MAINTAINER Thierry Corbin <thierry.corbin@kauden.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu vivid main universe" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade

RUN apt-get -y install php5 \
    php5-fpm \
    php5-gd \
    php5-ldap \
    php5-sqlite \
    php5-pgsql \
    php-pear \
    php5-mysql \
    php5-mcrypt \
    php5-xcache \
    php5-xmlrpc \
    nginx \
    supervisor

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ADD asset/supervisord.conf /opt/supervisord.conf
ADD asset/default /opt/default

RUN sed -i '/daemonize /c \daemonize = no' /etc/php5/fpm/php-fpm.conf && \
    sed -i '/;cgi.fix_pathinfo/c \cgi.fix_pathinfo=0' /etc/php5/fpm/php.ini && \
    cp -f /opt/default /etc/nginx/sites-available/default && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    mkdir /site && \
    chown www-data:www-data /site

RUN php5enmod mcrypt

EXPOSE 80

VOLUME /srv/http

CMD /usr/bin/supervisord -c /opt/supervisord.conf
