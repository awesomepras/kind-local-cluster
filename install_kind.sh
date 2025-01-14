#!/bin/bash

# Function to check the latest version of kind
get_latest_kind_version() {
    # Fetch the latest release version from GitHub
    latest_version=$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    echo "$latest_version"
}

# Function to install kind
install_kind() {
    local version=$1
    echo "Installing kind version $version..."

    # Download the latest kind binary
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/"$version"/kind-linux-amd64

    # Make the binary executable
    chmod +x ./kind

    # Move the binary to /usr/local/bin
    sudo mv ./kind /usr/local/bin/kind

    echo "kind version $version installed successfully."
}

# Main script execution
latest_version=$(get_latest_kind_version)
install_kind "$latest_version"

