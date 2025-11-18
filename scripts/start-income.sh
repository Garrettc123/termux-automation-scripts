#!/data/data/com.termux/files/usr/bin/bash
# Start all income generation systems

echo "Starting income generation systems..."

# Acquire wake lock
termux-wake-lock

echo "Starting background services..."

# Start monitoring
nohup ~/scripts/monitor.sh > ~/logs/monitor.log 2>&1 &

# Start crypto bot
if [ -f ~/scripts/crypto/trading-bot.sh ]; then
    nohup ~/scripts/crypto/trading-bot.sh > ~/logs/crypto.log 2>&1 &
fi

echo "All systems started!"
echo "Monitor with: tail -f ~/logs/monitor.log"
