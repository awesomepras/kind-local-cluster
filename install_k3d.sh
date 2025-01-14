#!/bin/bash

# Function to check the latest version of k3d
get_latest_k3d_version() {
    # Fetch the latest release version from GitHub using jq and follow redirects
    latest_version=$(curl -s -L https://api.github.com/repos/rancher/k3d/releases/latest | jq -r '.tag_name')
    echo "$latest_version"
}

# Function to install k3d
install_k3d() {
    local version=$1
    echo "Installing k3d version $version..."

    # Download the latest k3d binary
    curl -Lo /tmp/k3d https://github.com/rancher/k3d/releases/download/"$version"/k3d-linux-amd64

    # Make the binary executable
    chmod +x /tmp/k3d

    # Move the binary to /usr/local/bin
    sudo mv /tmp/k3d /usr/local/bin/k3d

    echo "k3d version $version installed successfully."
}

# Main script execution
latest_version=$(get_latest_k3d_version)
install_k3d "$latest_version"

