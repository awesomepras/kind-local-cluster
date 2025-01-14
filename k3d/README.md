# Intro
Alternative to kind, k3d can be used to deploy a k8s cluster. 

*Description:*
k3d makes it very easy to create single- and multi-node k3s clusters in docker, e.g. for local development on k8s

This repository contains scripts that can be used to automate the setup of kubernetes cluster using k3d
```
├── 1-install-k3dcluster.sh
├── 2-install-metallb.sh
├── 3-install-ingress-nginx.sh
├── 4-deploy-nginx-webserver.yaml
├── 5-deploy-ingressfornginx.yaml
├── cleanup-k3d.sh
```
Note for the `1-install-k3dcluster.sh` script, a docker network is created based on the clustername defined.  

* Post installation of cluster, there is rule to enables IP masquerading for the specified subnet (192.168.3.0/24). This rule allows packets originating from the 192.168.3.0/24 subnet to be forwarded to other networks while masquerading their source IP address.  
##  How to
_https://k3d.io/v5.6.0/#install-specific-release_

### Install:
`wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash`

### Create cluster (Manual)
`k3d cluster create mycluster`  
or  
`k3d cluster create dev-cluster   --k3s-arg "--disable=traefik@server:0" ` # (disables  Traefik as default ingress)
_https://github.com/k3d-io/k3d-demo/blob/main/assets/k3d-config.yaml_

The `1-install-k3dcluster.sh` script will create a docker network bridge to be used for the k3d cluster. 

![setup](k3d.svg)

### Check:
`kubectl get nodes`  
make sure you don't have a Traefik controller installed, run `kubectl get deployments -n kube-system` , there should be no Traefik information

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

# MetalLb
When you install MetalLB in a Kubernetes cluster, it primarily affects how services of type LoadBalancer are exposed to the outside world. MetalLB provides a way to allocate external IP addresses to these services, allowing them to be accessed from outside the cluster.

_https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/baremetal.md):](https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/baremetal.md_

### Install MetalLB in Layer 2 Mode:
Make sure to assign an IP address pool that is within the docker network.  


### Configure Ingress Controller with type LoadBalancer
```├── 3-install-ingress-nginx.sh```

_https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md#quick-start_

![metallb](https://github.com/kubernetes/ingress-nginx/blob/main/docs/images/baremetal/metallb.jpg)

It may take a few minutes for the load balancer IP to be available.  
You can watch the status by running `kubectl get service --namespace ingress-nginx ingress-nginx-controller`  

### Deploy ingress , followed by application pod and service  
```
├── 3-install-ingress-nginx.sh  
├── 4-deploy-nginx-webserver.yaml  
├── 5-deploy-ingressfornginx.yaml  
```
These scripts will setup the ingress to route traffic to kubernetes service for app nginx webserver.  

Optionally there is a netpolicy configuration that is set to allow traffic to port 80 to the pods  
### Some networking configuration 
* Bridge Between LAN and K3d Docker Network: 
  - Since k3d cluster is running in the Docker network 192.168.3.0/24, you must ensure routing is in place so that LAN traffic (from 192.168.2.0/24) can reach the MetalLB-assigned IPs. 
  - NAT and Host IP forwarding
  sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 ! -d 192.168.3.0/24 -j MASQUERADE

. Enable IP Forwarding on the master host where K8s Cluster is running
>  Check if IP forwarding is enabled
```cat /proc/sys/net/ipv4/ip_forward```

> If not enabled, enable it temporarily
``` sudo sysctl -w net.ipv4.ip_forward=1 ```

> To make it persistent, update sysctl.conf
```
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Add route to Docker network on client network
```sudo ip route add 192.168.3.0/24 via 192.168.2.100```

Run tcpdump on master host running docker network
```sudo tcpdump -i any host 192.168.3.241```

####  To Do: 
_https://istio.io/latest/docs/setup/platform-setup/k3d/_

