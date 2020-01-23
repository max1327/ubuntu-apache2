FROM ubuntu:18.04
# docker version has latest updates, so no need for upgrade

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

RUN apt-get -y update
RUN apt-get install lsb-release -y
RUN apt-get -y install apache2
RUN apt-get -y install php libapache2-mod-php php-mysql
RUN apt-get -y install supervisor

RUN ln -fs /usr/share/zoneinfo/Asia/Almaty /etc/localtime && dpkg-reconfigure -f noninteractive tzdata


RUN echo "[program:apache]" > /etc/supervisor/conf.d/apache.conf
RUN	echo "command=/usr/sbin/apachectl -DFOREGROUND -k start" >> /etc/supervisor/conf.d/apache.conf
RUN	echo "process_name = apache" >> /etc/supervisor/conf.d/apache.conf


#clean up
RUN apt-get -y autoclean && apt-get -y autoremove 
RUN apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g)
RUN rm -rf /var/lib/apt/lists/* 

VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /etc/apache2  

ADD startup.sh /root/startup.sh
CMD ["/bin/bash", "/root/startup.sh"]

EXPOSE 80
EXPOSE 443
