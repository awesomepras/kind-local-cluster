# Setup lab k8s cluster 

Few scripts that will setup a local kubernetes cluster
- k3d
- kind 


## Requirements

Docker installed locally

- Ref:  [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)
- Ref:  [https://docs.docker.com/engine/security/rootless/](https://docs.docker.com/engine/security/rootless/)

kind
-   macos:  `brew install kind`
-   Ubuntu:

>      curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
>      chmod +x ./kind
>      sudo mv ./kind /usr/local/bin/kind
or if you have golang installed, 
>      sudo apt-get instally -y golang
>      go install sigs.k8s.io/kind@v0.23.0

