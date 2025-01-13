#!/bin/bash
# make sure docker network is setup properly based on your subnet
# docker network create --subnet 10.10.1.0/24 --gateway 10.10.1.100 k3dnet
# k3d does not allow direct communication to underlying host, so idea is to create a separate docker network to be used by k3d cluster
# --------------------------------------------------------#
create_cluster() {
    # Check if CLUSTERNAME is empty and set default value
    if [ -z "${CLUSTERNAME}" ]; then
        CLUSTERNAME="dev-cluster"
    fi
    # Create the cluster using k3d
    k3d cluster create "${CLUSTERNAME}" --servers 1 --agents 1 --no-lb --k3s-arg "--disable=traefik@server:0" --k3s-arg "--disable=servicelb@server:0" --network "${CLUSTERNAME}" --trace
}
# Docker network definition
DSUBNET=192.168.3.0/24 
DGWY=192.168.3.1

# Read custom network name for Docker

read -p "Enter name for cluster (default: dev-cluster): " CLUSTERNAME

echo "Checking if docker network ${CLUSTERNAME} exists..."

# Check if the Docker network exists
if docker network inspect "${CLUSTERNAME}" > /dev/null 2>&1; then
    echo "Network '${CLUSTERNAME}' already exists"
else
    echo "Network '${CLUSTERNAME}' doesn't exist"
    echo "Creating custom Docker network ${CLUSTERNAME}..."
    docker network create --driver bridge --subnet=${DSUBNET} --gateway=${DGWY}  "${CLUSTERNAME}"
fi
# create ip masquerade 
# sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 ! -d 192.168.3.0/24 -j MASQUERADE
# Check if the MASQUERADE rule exists
if sudo iptables -t nat -C POSTROUTING -s $DSUBNET ! -d $DSUBNET -j MASQUERADE 2>/dev/null; then
    echo "MASQUERADE rule for $DSUBNET already exists."
else
    echo "MASQUERADE rule for $DSUBNET does not exist. Adding the rule..."
    sudo iptables -t nat -A POSTROUTING -s $DSUBNET ! -d $DSUBNET -j MASQUERADE
    echo "Rule added successfully."
fi

# Create the cluster
echo "Creating cluster..."
create_cluster

# Display cluster information
kubectl cluster-info

