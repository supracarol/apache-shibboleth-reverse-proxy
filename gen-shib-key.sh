#!/bin/bash

[[ -z "$1" ]] && { echo "Usage: $0 <hostname>" ; exit 1 ; }

HOSTNAME=$1
LIFETIME=3650 # 10 years

openssl req -new -x509 -sha256 -nodes \
	-days "$LIFETIME" -newkey rsa:2048 \
	-subj "/CN=$HOSTNAME" \
	-keyout ./sp-key.pem -out ./sp-cert.pem

## Inspect cert 
# openssl x509 -text -in cert.pem
