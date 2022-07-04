all: ansible-run

# prereq steps
sync-clock:
	# Ansible Ad-Hoc commands
	@./ensure-package-chrony-exists.sh

ansible-run:
	@yamllint ./roles/docker/
	@ansible-lint ./roles/docker/
	@ansible-galaxy install -r requirements.yml
	@ansible-playbook -i inventory -e network_interface=enp0s3 playbook.yml    

k8s-update:
	@ansible-playbook -i inventory -e network_interface=enp0s3 -e kube_override_hostname=dev-b02.k8s.loc k8s-update.yml

ping-nodes:
	@ansible multi -i inventory -a "date"

logs:
	@ansible multi -i inventory -b -m shell -a "tail -3 /var/log/syslog | grep  ansible-ansible.legacy.command"

master-ip:
	@ansible masters -i inventory -m setup | grep "ansible_default_ipv4" -A 2