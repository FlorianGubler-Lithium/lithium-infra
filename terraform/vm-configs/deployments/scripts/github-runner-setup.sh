#!/bin/bash
# GitHub Actions runner setup script
# Usage: ./github-runner-setup.sh <org> <token> [runner_name]
#
# Arguments:
# - org:        GitHub organization name (required)
# - token:      GitHub Actions runner registration token (required)
# - runner_name: Custom runner name, defaults to github-runner-<hostname> (optional)

set -euo pipefail

# Parse arguments
if [ $# -lt 2 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] ERROR: Insufficient arguments"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Usage: $0 <org> <token> [runner_name]"
    exit 1
fi

GITHUB_ORG="$1"
GITHUB_TOKEN="$2"
RUNNER_NAME="${3:-github-runner-$(hostname)}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Starting GitHub Actions runner setup"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Organization: $GITHUB_ORG"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Runner name: $RUNNER_NAME"

# Validate required arguments
if [ -z "$GITHUB_ORG" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] ERROR: GitHub organization not provided"
    exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] ERROR: GitHub token not provided"
    exit 1
fi

# Create runner user if it doesn't exist
if id "github-runner" &>/dev/null; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Runner user already exists"
else
    if useradd -m -s /bin/bash github-runner; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Created github-runner user"
    fi
fi

# Change to runner home directory
if ! cd /home/github-runner; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] ERROR: Could not change to runner home directory"
    exit 1
fi

# Install prerequisites
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Installing prerequisites"
apt-get update
apt-get install -y curl wget ca-certificates gnupg

# Determine architecture
ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
    amd64) DOWNLOAD_ARCH="x64" ;;
    arm64) DOWNLOAD_ARCH="arm64" ;;
    *) echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] ERROR: Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Download GitHub Actions runner
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Downloading GitHub Actions Runner"
LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases | grep 'tag_name' | sed -E 's/.*"v([^"]+)".*/\1/' | head -n 1)

if [ -z "$LATEST_VERSION" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] ERROR: Could not determine latest runner version"
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Latest version: v$LATEST_VERSION"

DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${LATEST_VERSION}/actions-runner-linux-${DOWNLOAD_ARCH}-${LATEST_VERSION}.tar.gz"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Download URL: $DOWNLOAD_URL"

curl -L -O "$DOWNLOAD_URL"

# Extract runner files
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Extracting runner files"
chown github-runner:github-runner "/home/github-runner/actions-runner-linux-${DOWNLOAD_ARCH}-${LATEST_VERSION}.tar.gz"
su - github-runner -c "tar xzf actions-runner-linux-${DOWNLOAD_ARCH}-${LATEST_VERSION}.tar.gz"
rm "actions-runner-linux-${DOWNLOAD_ARCH}-${LATEST_VERSION}.tar.gz"

# Register the runner
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Registering runner with GitHub organization"
su - github-runner -c "cd /home/github-runner && ./config.sh --url 'https://github.com/${GITHUB_ORG}' --token '${GITHUB_TOKEN}' --name '${RUNNER_NAME}' --runnergroup 'Default' --work '_work' --replace --unattended"

if [ $? -ne 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] ERROR: Failed to register runner"
    exit 1
fi

# Install and enable systemd service
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Installing systemd service"
su - github-runner -c 'cd /home/github-runner && ./svc.sh install'

# Start the service
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] Starting systemd service"
sudo systemctl daemon-reload
sudo systemctl enable github-actions.runner
sudo systemctl start github-actions.runner

# Verify service is running
sleep 2
if sudo systemctl is-active --quiet github-actions.runner; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] GitHub Actions runner is running"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] WARNING: GitHub Actions runner service is not running"
    sudo systemctl status github-actions.runner
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [github-runner-setup] GitHub Actions runner setup completed successfully!"

