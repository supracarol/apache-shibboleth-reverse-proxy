# Apache Shibboleth Reverse Proxy Image

## Description
Apache Shibboleth Docker image that generates reverse proxy 
configuration for path based routing from environment
variables passed at container start.

## Usage


```bash

$ SERVER_NAME=https://example.com:443
$ SHIB_SCHEME=https
$ ENTITY_ID=https://example.com/shibboleth
$ IDP_ENTITY_ID=https://idp.example.com/idp/shibboleth
$ SUPPORT_CONTACT=admin@example.com
$ PROXY_PASS_APP1_SRC=/app1
$ PROXY_PASS_APP1_TGT=http://app1:8080
$ PROXY_PASS_APP2_SRC=/app2
$ PROXY_PASS_APP2_TGT=http://app2:3000
$ SP_CERT="$(cat ./sp-cert.pem)"
$ SP_KEY="$(cat ./sp-key.pem)"
$ docker run -d -p 80:80 -p 443:443 --name apache-shib supracarol/apache-shibboleth-reverse-proxy:0.0.1

```

## Todo
- [ ] Customize attribute-map.xml
- [ ] https cookies in shibboleth.xml


