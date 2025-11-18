#!/data/data/com.termux/files/usr/bin/bash
# System monitoring script

while true; do
    clear
    echo "====================================="
    echo "System Monitor - $(date)"
    echo "====================================="
    echo ""
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | head -n1
    echo ""
    echo "Memory:"
    free -h
    echo ""
    echo "Disk:"
    df -h $HOME
    echo ""
    echo "Active Processes:"
    ps aux | grep -E 'python|node' | grep -v grep | wc -l
    echo ""
    echo "Press Ctrl+C to exit"
    
    sleep 5
done
