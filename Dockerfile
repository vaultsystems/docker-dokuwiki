# VERSION 0.1
# AUTHOR:         Miroslav Prasil <miroslav@prasil.info>
# DESCRIPTION:    Image with DokuWiki & lighttpd
# TO_BUILD:       docker build -t mprasil/dokuwiki .
# TO_RUN:         docker run -d -p 80:80 --name my_wiki mprasil/dokuwiki


FROM ubuntu:14.04
MAINTAINER Miroslav Prasil <miroslav@prasil.info>

# Set the version you want of Twiki
ENV DOKUWIKI_VERSION 2014-09-29d
ENV DOKUWIKI_CSUM 2bf2d6c242c00e9c97f0647e71583375

ENV LAST_REFRESHED 7. April 2015
# Update & install packages
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget \
	lighttpd \
	php5-cgi \
	php5-gd

# Download & deploy twiki
RUN wget -O /dokuwiki.tgz \
	"http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz"
RUN if [ "$DOKUWIKI_CSUM" != "$(md5sum /dokuwiki.tgz | awk '{print($1)}')" ];\
  then echo "Wrong md5sum of downloaded file!"; exit 1; fi;
RUN tar -zxf dokuwiki.tgz
RUN mv "/dokuwiki-$DOKUWIKI_VERSION" /dokuwiki

# Set up ownership
RUN chown -R www-data:www-data /dokuwiki

# Cleanup
RUN rm dokuwiki.tgz

# Configure lighttpd
ADD dokuwiki.conf /etc/lighttpd/conf-available/20-dokuwiki.conf
RUN lighty-enable-mod dokuwiki fastcgi accesslog
RUN mkdir /var/run/lighttpd && chown www-data.www-data /var/run/lighttpd

EXPOSE 80
VOLUME ["/dokuwiki/data/","/dokuwiki/lib/plugins/","/dokuwiki/conf/","/dokuwiki/lib/tpl/","/var/log/"]

ENTRYPOINT ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

