#!/data/data/com.termux/files/usr/bin/bash
# Initialize cryptocurrency wallet

echo "Initializing crypto wallet..."

# Install required packages
pkg install -y nodejs-lts python

# Install web3 tools
npm install -g web3 ethers

echo "Wallet initialization complete!"
echo "IMPORTANT: Backup your keys securely!"
