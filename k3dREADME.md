# Intro
Alternative to kind, k3d can be used to deploy a k8s cluster

*Description:*
k3d makes it very easy to create single- and multi-node k3s clusters in docker, e.g. for local development on k8s


##  How to
_https://k3d.io/v5.6.0/#install-specific-release_

### Install:
`wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash`

### Create:
`k3d cluster create mycluster`
or
` kind cluster create mycluster --no-deploy-traefik ` # to prevent install Traefik as default ingress Class


### Check:
`kubectl get nodes`
make sure you don't have a Traefik controller installed, run `kubectl get deployments -n kube-system`  to see if Traefik is gone.
## Using Image Registries:

Create a dedicated registry together with your cluster: 
You can add registries by specifying them in a registries.yaml and referencing it at creation time: 

`k3d cluster create mycluster --registry-config "/home/YOU/my-registries.yaml"`
or 
`k3d cluster create mycluster --registry-create mycluster-registry`
This creates your cluster mycluster together with a registry container called mycluster-registry

* k3d sets everything up in the cluster for containerd to be able to pull images from that registry (using the registries.yaml file)
* the port, which the registry is listening on will be mapped to a random port on your host system
* Check the k3d command output or docker ps -f name=mycluster-registry to find the exposed port


## Multi-server Clusters
` k3d cluster create multinode --agents 2 --servers 2`

#### Whats next:
https://istio.io/latest/docs/setup/platform-setup/k3d/

