# https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html
set -ex
ansible multi -b -i inventory -m apt -a "name=chrony state=present"
# https://opensource.com/article/18/12/manage-ntp-chrony
# I like to set the system hardware clock from the system (OS) time
ansible multi -b -i inventory -a "/sbin/hwclock --systohc"
ansible multi -b -i inventory -a "chronyc sources"
ansible multi -b -i inventory -a "chronyc tracking"
