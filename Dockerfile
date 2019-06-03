#base image
FROM ubuntu:latest
MAINTAINER mohammad samour <m.fares1@yahoo.com>

#Updating packages
RUN apt-get -q -y update

#Installing mysql
RUN apt-get -y install mysql-server supervisor 
EXPOSE 3306

COPY  supervisord.conf  /etc/supervisor/
COPY my.cnf /etc/mysql

RUN  touch /var/run/supervisor.sock
RUN  chmod 777 /var/run/supervisor.sock
RUN  service supervisor restart

#Running Supervisor daemon
ENTRYPOINT service supervisor start && /bin/bash



#grant access to from all IPs and users, this is only for testing purposes.
RUN service mysql start && \
mysql -u root -p  -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'test' WITH GRANT OPTION;CREATE DATABASE wordpress;CREATE USER 'wordpressuser'@'%' IDENTIFIED BY 'test';GRANT ALL ON wordpress.* TO 'wordpressuser'@'%' IDENTIFIED BY 'test' WITH GRANT OPTION;FLUSH PRIVILEGES;"







