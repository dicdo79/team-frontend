FROM ubuntu:20.04

# Apache 소스 설치를 위한 패키지
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apache2 apache2-dev build-essential wget

# Install mod_jk
RUN wget -P ~ https://dlcdn.apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.49-src.tar.gz --no-check-certificate \
      && cd ~ \
      && tar -zxvf tomcat-connectors-1.2.49-src.tar.gz \
      && rm -rf tomcat-connectors-1.2.49-src.tar.gz \
      && cd ~/tomcat-connectors-1.2.49-src/native/ \
      && ./configure --with-apxs=/usr/bin/apxs \
      && make && make install

# Copy enable and load httpd conf files that it locate conf/sites
ADD ./conf/httpd.conf /etc/apache2/apache2.conf
ADD ./conf/mod_jk.conf /etc/apache2/mods-available/jk.conf
ADD ./conf/workers.properties /etc/apache2/workers.properties
ADD ./conf/uri.properties /etc/apache2/uri.properties

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart 
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
