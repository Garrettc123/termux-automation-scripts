#!/data/data/com.termux/files/usr/bin/bash
# Crypto trading bot launcher

echo "Starting crypto trading bot..."

# Check if Python is available
if ! command -v python &> /dev/null; then
    echo "Installing Python..."
    pkg install -y python
fi

# Acquire wake lock for continuous operation
termux-wake-lock

echo "Trading bot active!"
echo "Monitor at: ~/logs/trading.log"

# Keep running
while true; do
    python ~/termux-automation-scripts/scripts/crypto/bot.py
    sleep 60
done
