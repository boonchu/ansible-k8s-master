# https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/
# kubectl run -it --rm --restart=Never --image=infoblox/dnstools:latest dnstools

#kubectl delete -n default pod/dnsutils
cat <<-ECHO | kubectl apply -n default -f -
apiVersion: v1
kind: Pod
metadata:
  name: dnsutils
  namespace: default
spec:
  containers:
  - name: dnsutils
    image: gcr.io/kubernetes-e2e-test-images/dnsutils:1.3
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    resources:
      requests:
        memory: "48Mi"
        cpu: "48m"
      limits:
        memory: "64Mi"
        cpu: "64m"
  restartPolicy: Always
ECHO

kubectl wait pod dnsutils --for condition=containersready --timeout=60s

kubectl exec -n default -it dnsutils -- nslookup kubernetes.default
kubectl exec -n default -ti dnsutils -- cat /etc/resolv.conf
kubectl exec -n default -it dnsutils -- nslookup k8s.gcr.io.
kubectl get svc -o wide --namespace=kube-system
