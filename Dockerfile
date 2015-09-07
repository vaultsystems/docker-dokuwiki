FROM alpine
MAINTAINER Christoph Dwertmann <cdwertmann@gmail.com>

# Set the version of Dokuwiki
ENV DOKUWIKI_VERSION 2015-08-10a

# Update & install packages
RUN apk --update add lighttpd php-cgi php-gd curl supervisor logrotate && rm /var/cache/apk/*

# Download & deploy
RUN curl "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" | tar xvz && \
    mv "/dokuwiki-$DOKUWIKI_VERSION" /dokuwiki && \
    chown -R lighttpd. /dokuwiki && \
    rm /etc/logrotate.d/*

# Configure lighttpd
RUN echo 'include "dokuwiki.conf"' >> /etc/lighttpd/lighttpd.conf
ADD dokuwiki.conf /etc/lighttpd/

RUN cd /var/log/lighttpd; mkfifo access.log error.log; chown -R lighttpd. *

EXPOSE 80
VOLUME ["/dokuwiki/data/","/dokuwiki/lib/plugins/","/dokuwiki/conf/","/dokuwiki/lib/tpl/"]

CMD cat /var/log/lighttpd/access.log & cat /var/log/lighttpd/error.log & /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
