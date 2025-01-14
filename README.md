# Setup lab k8s cluster 

Few scripts that will setup a local kubernetes cluster
- k3d
- kind 


## Requirements

Docker installed locally

- Ref:  [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)
- Ref:  [https://docs.docker.com/engine/security/rootless/](https://docs.docker.com/engine/security/rootless/)

### k3d:
```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```
### kind: 
_https://kind.sigs.k8s.io/docs/user/quick-start/_

-   macos:  `brew install kind`
-   Ubuntu: (obtain latest version0

>      curl -Lo ./kind https://kind.sigs.k8s.io/dl/(version)/kind-linux-amd64
>      chmod +x ./kind
>      sudo mv ./kind /usr/local/bin/kind
or if you have golang installed, 
>      sudo apt-get instally -y golang
>      go install sigs.k8s.io/kind@v0.23.0

## scripts
```
.
├── install_k3d.sh
├── install_kind.sh
```
