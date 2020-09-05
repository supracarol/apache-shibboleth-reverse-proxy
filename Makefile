MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --always-make
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
SHELL:=bash

APACHE_IMAGE:=httpd:2.4
BUILD_IMG:=supracarol/apache-shibboleth-reverse-proxy:0.0.1

build:
	docker build -t $(BUILD_IMG) .

shell:
	docker run \
	-it \
	--rm \
	$(BUILD_IMG) \
	bash

gen-fresh-templates:
	docker run --rm $(APACHE_IMAGE) cat /usr/local/apache2/conf/httpd.conf > httpd.conf.tpl
