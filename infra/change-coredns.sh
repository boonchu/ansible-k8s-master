#!/bin/bash 

# DNS issue in kind
# https://github.com/kubernetes-sigs/kind/issues/1216

cat <<-ECHO | kubectl apply -n kube-system -f - 
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward . 172.30.30.52
        cache 30
        loop
        log
        reload
        loadbalance
    }
ECHO
kubectl rollout restart -n kube-system deployment coredns

# kubectl wait -n kube-system deployment coredns --for condition=available --timeout 60s
for i in $(kubectl get pod -l k8s-app=kube-dns -o jsonpath="{.items[*].metadata.name}"); do
    kubectl wait -n kube-system pod $i --for=condition=containersready
done

./check_dns.sh
