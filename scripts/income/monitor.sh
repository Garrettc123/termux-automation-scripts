#!/data/data/com.termux/files/usr/bin/bash
# Monitor income streams

while true; do
    clear
    echo "====================================="
    echo "Income Monitor - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "====================================="
    echo ""
    
    if [ -f ~/data/earnings.json ]; then
        echo "Today's Earnings:"
        cat ~/data/earnings.json | grep total
    else
        echo "No earnings data yet"
    fi
    
    echo ""
    echo "Active Processes:"
    ps aux | grep -E 'bot|income' | grep -v grep
    
    echo ""
    echo "Press Ctrl+C to exit"
    sleep 10
done
