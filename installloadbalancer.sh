#!/bin/bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

echo "wait for speaker pods to come up....."
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s
read -p "once up continue.."
docker network inspect -f '{{.IPAM.Config}}' kind
kubectl apply -f https://kind.sigs.k8s.io/examples/loadbalancer/metallb-config.yaml

