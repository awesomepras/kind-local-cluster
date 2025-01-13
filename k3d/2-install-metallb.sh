#!/bin/bash
#https://metallb.universe.tf/installation/
#!/bin/bash

# Fetch the latest MetalLB release version from GitHub API
METALLB_VERSION=$(curl -s https://api.github.com/repos/metallb/metallb/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$METALLB_VERSION" ]; then
  echo "Failed to fetch the latest MetalLB version."
  exit 1
fi

echo "Latest MetalLB version: $METALLB_VERSION"

# Apply the MetalLB manifest using the latest version
kubectl apply -f "https://raw.githubusercontent.com/metallb/metallb/${METALLB_VERSION}/config/manifests/metallb-native.yaml"


echo "wait for speaker pods to come up....."
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s
read -p "once up continue.."
DNET=$(docker network ls |grep bridge|awk '{print $2}' |grep -v bridge)
docker network inspect ${DNET}
#https://kind.sigs.k8s.io/examples/loadbalancer/metallb-config.yaml
kubectl apply -f layer2-config.yaml 

# Verify
kubectl get daemonsets -n metallb-system
kubectl get deployments -n metallb-system
kubectl get pods -n metallb-system
