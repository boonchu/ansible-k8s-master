# inspired from this project
https://github.com/kairen/kubeadm-ansible
https://devopstales.github.io/kubernetes/k8s-metallb-bgp-pfsense/

# objectives

scripts can perform the following steps on the host prior to delegating to kubeadm init.

[x] Check OS compatibility
[x] Check Docker compatibility if pre-installed
[x] Disable swap
[x] Check SELinux
[x] Install Docker/Containerd
[x] Install Kubeadm, Kubelet, Kubectl and CNI packages
[x] Generate Kubeadm config files from flags passed to the script
[ ] Load kernel modules required for running Kube-proxy in IPVS mode
[x] Configure Docker and Kubernetes to work behind a proxy if detected

# developing modules
https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html

# creating roles
https://galaxy.ansible.com/docs/contributing/creating_role.html

# videos
https://www.youtube.com/watch?v=WNmKjtWtqIc

# dynamic inventory demo
https://devopscube.com/setup-ansible-aws-dynamic-inventory/

# k8s rolling upgrade
https://github.com/kubernetes-sigs/kubespray/blob/master/docs/upgrades.md
https://itnext.io/automating-system-updates-for-kubernetes-clusters-using-ansible-94a70f4e1972
https://github.com/kevincoakley/ansible-role-k8s-rolling-update

# k8s pods eviction from nodes
https://dbafromthecold.com/2020/04/08/adjusting-pod-eviction-time-in-kubernetes/

# Excel spreadsheet Host variables
https://github.com/KeyboardInterrupt/ansible_xlsx_inventory


#### How to run?

$ python3 -m venv venv

$ venv/bin/activate 

$ pip3 install -r requirements.txt

$ ansible-galaxy role install -r requirements.yml

$ make sync-clock

$ make all


