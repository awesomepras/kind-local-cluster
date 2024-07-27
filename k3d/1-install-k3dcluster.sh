#!/bin/bash
read -p "enter name for cluster: (dev-cluster)" clustername
if $clustername=''; then
  clustername=dev-clustername
fi
k3d cluster create $clustername   --k3s-arg "--disable traefik,servicelb"

kubectl cluster-info
