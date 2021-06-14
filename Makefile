all: ansible-run

# prereq steps
sync-clock:
	@./ensure-package-chrony-exists.sh

ansible-run:
	@yamllint ./roles/docker/
	@ansible-playbook -i inventory -e network_interface=eth0  playbook.yaml    

k8s-update:
	@ansible-playbook -i inventory -e network_interface=eth0 k8s-update.yaml

ping-nodes:
	@ansible multi -i inventory -a "date"

logs:
	@ansible multi -i inventory -b -m shell -a "tail -3 /var/log/syslog | grep  ansible-ansible.legacy.command"

master-ip:
	@ansible masters -i inventory -m setup | grep "ansible_default_ipv4" -A 2
