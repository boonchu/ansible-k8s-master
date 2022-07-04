#!/bin/bash
echo "Creating certificates"
mkdir -p certs/ca

HOSTNAME=dev-b99.k8s.loc

# Create a root CA
openssl genrsa -out certs/ca/ca.key 2048
openssl req -new -key certs/ca/ca.key -out certs/ca/ca.csr
openssl x509 -req -in certs/ca/ca.csr -out certs/ca/ca-cert.crt -signkey certs/ca/ca.key -days "3650"
# Create a self-signed server certificate using above CA certificate
openssl genrsa -out certs/server.key 2048
openssl req -new -key certs/server.key -out certs/server.csr -subj "/CN=HOSTNAME"

openssl x509 -req -extfile <(printf "subjectAltName=DNS:$HOSTNAME, DNS:trivy.k8s.loc, DNS:192.168.60.101") -in certs/server.csr -signkey certs/server.key -out certs/server.crt -CA certs/ca/ca-cert.crt -CAkey certs/ca/ca.key -days 3650 -CAcreateserial
