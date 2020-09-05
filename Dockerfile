FROM httpd:2.4
RUN apt-get update && apt-get install -y \
	libapache2-mod-shib2
COPY ./app/httpd.conf.tpl /usr/local/apache2/conf/httpd.conf
COPY ./app/shibboleth2.xml.tpl /etc/shibboleth/shibboleth2.xml
COPY ./app/custom-entrypoint.sh /
CMD ["/custom-entrypoint.sh"]
