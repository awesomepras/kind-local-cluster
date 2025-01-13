#!/bin/sh
helm upgrade --install ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--namespace ingress-nginx --create-namespace
echo "----install done--"
kubectl -n ingress-nginx get svc
kubectl get ingressClass
