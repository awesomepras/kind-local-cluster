#!/bin/bash
#https://metallb.universe.tf/installation/
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml
echo "wait for speaker pods to come up....."
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s
read -p "once up continue.."
docker network inspect -f '{{.IPAM.Config}}' kind
#https://kind.sigs.k8s.io/examples/loadbalancer/metallb-config.yaml
kubectl apply -f layer2-config.yaml 

# Verify
kubectl get daemonsets -n metallb-system
kubectl get deployments -n metallb-system
kubectl get pods -n metallb-system
