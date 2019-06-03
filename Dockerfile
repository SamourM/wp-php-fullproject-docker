#base image
FROM ubuntu:latest     
MAINTAINER mohammad samour <m.fares1@yahoo.com>

# to prevent the user intervetion when tzdata asks for the time zone
ENV DEBIAN_FRONTEND=noninteractive

# Updating and Installing the needed packages 
RUN apt-get -q -y update  
RUN apt -y install mysql-client  software-properties-common wget curl  nginx  supervisor curl php-fpm php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl #install php-fpm
EXPOSE  80
#apt install mysql-server
#EXPOSE 3306

#get wordpress files and extract them
RUN wget https://wordpress.org/wordpress-5.2.tar.gz  
RUN tar -xvzf wordpress-5.2.tar.gz
RUN mv wordpress /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chmod -R 755 /var/www/html/wordpress/ 
COPY wordpress  /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
RUN  rm /etc/nginx/sites-enabled/default
RUN mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

#creating the needed dirs for FPM
RUN mkdir -p /var/log/php-fpm
RUN mkdir -p /var/run/php

#Copying the configuration files
COPY  wp-config.php /var/www/html/wordpress/
COPY  supervisord.conf  /etc/supervisor/
COPY  php.ini /etc/php/7.2/cli/
#COPY  mysql.conf  /etc/supervisor/conf.d/ 
#Configuring Supervisor

RUN  touch /var/run/supervisor.sock
RUN  chmod 777 /var/run/supervisor.sock
RUN  service supervisor restart   

#Running Supervisor daemon
ENTRYPOINT service supervisor start && /bin/bash

#Running other services
RUN service nginx start
RUN service php7.2-fpm start



 



