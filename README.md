# Setup lab k8s cluster with kind

Few scripts that will setup a local kubernetes cluster with kind.

Ref: https://kind.sigs.k8s.io/docs/user/quick-start/

# Files

The script `kind-with-registry.sh` will setup kind cluster and setup local registry to upload your artifact
The script `dashboard.sh`will setup and start the kubernetes dashboard
The script `gettokenfordashboard.sh`will retrieve the token to be used for login to the dashboard

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

### install metallb for loadbalancing
- Ref [https://kind.sigs.k8s.io/docs/user/loadbalancer/](https://kind.sigs.k8s.io/docs/user/loadbalancer/)

### How to push local docker image to kind registry
Tag the image to use the local registry 
```
docker tag hello-python:0.0.1 localhost:5001/hello-python:0.0.1
```
Then docker push 
```
docker push localhost:5001/hello-python:0.0.1
```

Verify:
```
curl http://127.0.0.1:5001/v2/_catalog  
curl http://127.0.0.1:5001/v2/hello-python/tags/list
 ```
