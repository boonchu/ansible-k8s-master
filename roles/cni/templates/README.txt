# update template
wget -O roles/cni/templates/calico.yml.j2 https://docs.projectcalico.org/manifests/calico.yaml

# setup environment variable
3680             # The default IPv4 pool to create on startup if none exists. Pod IPs will be
3681             # chosen from this range. Changing this value after installation will have
3682             # no effect. This should fall within `--cluster-cidr`.
3683             - name: CALICO_IPV4POOL_CIDR
3684               value: "{{ pod_network_cidr }}"
