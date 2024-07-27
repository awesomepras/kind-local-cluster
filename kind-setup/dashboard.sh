#!/bin/sh
set -o errexit
#kind get clusters
#kubectl cluster-info --context kind-java-sampleapp-dev
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
helm install dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard --create-namespace
cat <<EOF | kubectl replace -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: admin-user-token
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user 
EOF
kubectl describe serviceaccount admin-user -n kubernetes-dashboard
kubectl describe secret admin-user-token -n kubernetes-dashboard
