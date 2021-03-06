FROM sameersbn/ubuntu:14.04.20170123
MAINTAINER @mayanktahil github

ENV BIND_USER=bind \
    BIND_VERSION=1:9.9.5 \
    WEBMIN_VERSION=1.8 \
    DATA_DIR=/data

RUN mkdir /data

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && wget http://www.webmin.com/jcameron-key.asc -qO - | apt-key add - \
 && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bind9=${BIND_VERSION}* bind9-host=${BIND_VERSION}* webmin=${WEBMIN_VERSION}* \
 && apt-get -y -f install isc-dhcp-server \
 && rm -rf /var/lib/apt/lists/*

ADD ./scripts/* /sbin/
RUN chmod 755 /sbin/entrypoint.sh && \
		chmod +x /sbin/add-user.sh && \
		useradd -m -s /bin/bash admin

EXPOSE 53/udp 53/tcp 67/udp 68/udp 10000/tcp 
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
