#!/bin/bash

set -ex

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner  \
  --set nfs.server=192.168.60.99 --set nfs.path=/nfs/vol1
