#### admission control and validate with Trivy ####

-- https://medium.com/@AbhijeetKasurde/using-kubernetes-admission-controllers-1e5ba5cc30c0

#### target node 'dev-b99'  ####
- create_ssl.sh

#!/bin/bash
echo "Creating certificates"
mkdir -p certs/ca

HOSTNAME=dev-b99.k8s.loc

#### Create a root CA ####

openssl genrsa -out certs/ca/ca.key 2048
openssl req -new -key certs/ca/ca.key -out certs/ca/ca.csr
openssl x509 -req -in certs/ca/ca.csr -out certs/ca/ca-cert.crt -signkey certs/ca/ca.key -days "3650"
# Create a self-signed server certificate using above CA certificate
openssl genrsa -out certs/server.key 2048
openssl req -new -key certs/server.key -out certs/server.csr -subj "/CN=HOSTNAME"

openssl x509 -req -extfile <(printf "subjectAltName=DNS:$HOSTNAME, DNS:trivy.k8s.loc, DNS:192.168.60.101") -in certs/server.csr -signkey certs/server.key -out certs/server.crt -CA certs/ca/ca-cert.crt -CAkey certs/ca/ca.key -days 3650 -CAcreateserial


#### install 'trivy' ####

- https://betterprogramming.pub/static-analysis-of-container-images-with-trivy-8d297c4f1dd3#:~:text=To%20install%20Trivy%20on%20Ubuntu%2C%20use%20the%20following,%28lsb_release%20-sc%29%20main%20%7C%20sudo%20tee%20-a%20%2Fetc%2Fapt%2Fsources.list.d%2Ftrivy.list

$ sudo apt-get install wget apt-transport-https gnupg lsb-release
$ wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
$ echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
$ sudo apt-get update
$ sudo apt-get install trivy
$ trivy --version


#### Create CA Bundle

echo $(cat certs/ca/ca-cert.crt  | base64 -w 0) # save this output to fill in admission_control.yaml


#### install application

virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
python3 app.py


#### apply admission controller to validate image

-- admission_control.yaml --

apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: "trivy.k8s.loc"
webhooks:
- name: "trivy.k8s.loc"
  rules:
  - apiGroups:   [""]
    apiVersions: ["v1"]
    operations:  ["CREATE"]
    resources:   ["pods"]
    scope:       "Namespaced"
  clientConfig:
    url: https://dev-b99.k8s.loc:6443/validate
    caBundle: "$(cat certs/ca/ca-cert.crt  | base64 -w 0)"
  admissionReviewVersions: ["v1", "v1beta1"]
  sideEffects: None
  timeoutSeconds: 5


$ k apply -f admission_control.yaml
$ k get validatingwebhookconfigurations.admissionregistration.k8s.io
NAME            WEBHOOKS   AGE
trivy.k8s.loc   1          32s
