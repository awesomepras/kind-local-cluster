#!/bin/bash
CLUSTERNAME=$(k3d cluster ls --no-headers|awk '{print $1}')
k3d cluster delete ${CLUSTERNAME}
docker network rm ${CLUSTERNAME}
