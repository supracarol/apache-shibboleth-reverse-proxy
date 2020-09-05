#!/bin/bash

set -euo pipefail

## Generate ProxyPass configuration

proxy_apps=$(compgen -A variable | grep PROXY_PASS_ | sed 's/^PROXY_PASS_\(.*\)_\(SRC\|TGT\)/\1/' | sort | uniq) || true

proxy_pass_cfg=

if [[ -n "$proxy_apps" ]]; then

	for app in $proxy_apps; do 
		SRC=$(compgen -A variable | grep $app | grep SRC | head -1)
		TGT=$(compgen -A variable | grep $app | grep TGT | head -1)
		proxy_pass_cfg=$(printf "${proxy_pass_cfg}\nProxyPass ${!SRC} ${!TGT}")
		proxy_pass_cfg=$(printf "${proxy_pass_cfg}\nProxyPassReverse ${!SRC} ${!TGT}")
	done

	perl -i -pe 's%<PROXY_CFG>%'"$proxy_pass_cfg"'%g' /usr/local/apache2/conf/httpd.conf
else
	perl -i -pe 's%<PROXY_CFG>%%g' /usr/local/apache2/conf/httpd.conf
fi

sed -i 's%<SERVER_NAME>%'$SERVER_NAME'%g' /usr/local/apache2/conf/httpd.conf 

# Configure Shibboleth

perl -i -pe 's%<IDP_ENTITY_ID>%'"$IDP_ENTITY_ID"'%g' /etc/shibboleth/shibboleth2.xml
perl -i -pe 's%<ENTITY_ID>%'"$ENTITY_ID"'%g' /etc/shibboleth/shibboleth2.xml
perl -i -pe 's%<SHIB_SCHEME>%'"$SHIB_SCHEME"'%g' /etc/shibboleth/shibboleth2.xml

perl -i -pe 's%<SUPPORT_CONTACT>%'"$SUPPORT_CONTACT"'%g' /etc/shibboleth/shibboleth2.xml

echo "$SP_KEY" > /etc/shibboleth/sp-key.pem
echo "$SP_CERT" > /etc/shibboleth/sp-cert.pem

cp /usr/lib/apache2/modules/mod_shib.so /usr/local/apache2/modules/mod_shib.so


service shibd start

a2enmod shib

httpd-foreground


