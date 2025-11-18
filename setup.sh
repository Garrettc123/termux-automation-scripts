#!/data/data/com.termux/files/usr/bin/bash
# Termux Initial Setup Script

set -e

echo "====================================="
echo "Termux Automation Setup"
echo "====================================="
echo ""

# Update packages
echo "Updating packages..."
pkg upgrade -y

# Install essential packages
echo "Installing essential packages..."
pkg install -y \
    git \
    curl \
    wget \
    python \
    nodejs-lts \
    openssh \
    rsync \
    vim \
    htop

# Install development tools
echo "Installing development tools..."
pkg install -y \
    build-essential \
    clang \
    cmake \
    make

# Setup storage access
echo "Setting up storage access..."
termux-setup-storage

# Create directory structure
echo "Creating directories..."
mkdir -p ~/scripts
mkdir -p ~/data
mkdir -p ~/logs
mkdir -p ~/.shortcuts

# Copy scripts
cp scripts/*.sh ~/scripts/
chmod +x ~/scripts/*.sh

echo ""
echo "✓ Setup complete!"
echo "Run: ~/scripts/start-income.sh to begin"
