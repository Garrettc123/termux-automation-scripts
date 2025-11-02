#!/data/data/com.termux/files/usr/bin/bash

# Automated System Update and Maintenance Script
# Keeps all systems updated and running optimally
# Copyright (c) 2025 Garrett Christensen

set -e

# Configuration
LOG_DIR="$HOME/workspace/logs"
BACKUP_DIR="$HOME/workspace/backups"
DATE=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/auto_update_$DATE.log"

# Create directories
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

# Logging functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error() {
    echo "[ERROR] $1" | tee -a "$LOG_FILE"
    exit 1
}

# System update function
update_system() {
    log "Starting system update..."
    
    # Update package lists
    pkg update -y || error "Failed to update package lists"
    
    # Upgrade packages
    pkg upgrade -y || error "Failed to upgrade packages"
    
    # Clean package cache
    pkg clean || log "Warning: Failed to clean package cache"
    
    log "System update completed successfully"
}

# Python packages update
update_python_packages() {
    log "Updating Python packages..."
    
    # Update pip
    pip install --upgrade pip || log "Warning: Failed to upgrade pip"
    
    # Get list of outdated packages
    outdated_packages=$(pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 || true)
    
    if [[ -n "$outdated_packages" ]]; then
        log "Updating outdated Python packages: $outdated_packages"
        echo "$outdated_packages" | xargs -r pip install --upgrade
    else
        log "All Python packages are up to date"
    fi
    
    log "Python packages update completed"
}

# Node.js packages update
update_nodejs_packages() {
    log "Updating Node.js packages..."
    
    # Update npm
    npm install -g npm@latest || log "Warning: Failed to update npm"
    
    # Update global packages
    npm update -g || log "Warning: Failed to update global npm packages"
    
    log "Node.js packages update completed"
}

# Git repositories update
update_git_repositories() {
    log "Updating Git repositories..."
    
    # Find all git repositories in workspace
    find "$HOME/workspace" -name ".git" -type d | while read git_dir; do
        repo_dir=$(dirname "$git_dir")
        log "Updating repository: $repo_dir"
        
        cd "$repo_dir"
        
        # Check if there are uncommitted changes
        if [[ -n $(git status --porcelain) ]]; then
            log "Warning: Uncommitted changes in $repo_dir, skipping update"
            continue
        fi
        
        # Pull latest changes
        git pull origin $(git branch --show-current) || log "Warning: Failed to update $repo_dir"
    done
    
    log "Git repositories update completed"
}

# Backup critical data
backup_data() {
    log "Creating backup..."
    
    backup_file="$BACKUP_DIR/system_backup_$DATE.tar.gz"
    
    # Backup critical directories
    tar -czf "$backup_file" \
        "$HOME/workspace/config" \
        "$HOME/workspace/data" \
        "$HOME/workspace/scripts" \
        2>/dev/null || log "Warning: Some files could not be backed up"
    
    if [[ -f "$backup_file" ]]; then
        log "Backup created: $backup_file"
        
        # Keep only last 7 backups
        ls -t "$BACKUP_DIR"/system_backup_*.tar.gz | tail -n +8 | xargs -r rm
        log "Old backups cleaned up"
    else
        log "Warning: Backup creation failed"
    fi
}

# Clean temporary files
clean_temp_files() {
    log "Cleaning temporary files..."
    
    # Clean Python cache
    find "$HOME/workspace" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
    find "$HOME/workspace" -name "*.pyc" -delete 2>/dev/null || true
    
    # Clean old log files (older than 30 days)
    find "$LOG_DIR" -name "*.log" -mtime +30 -delete 2>/dev/null || true
    
    # Clean npm cache
    npm cache clean --force 2>/dev/null || true
    
    log "Temporary files cleaned"
}

# Check system health
check_system_health() {
    log "Checking system health..."
    
    # Check disk space
    disk_usage=$(df "$HOME" | tail -1 | awk '{print $5}' | sed 's/%//')
    if [[ $disk_usage -gt 90 ]]; then
        log "Warning: Disk usage is high ($disk_usage%)"
    else
        log "Disk usage: $disk_usage%"
    fi
    
    # Check memory usage
    memory_info=$(free -h | grep '^Mem:' || echo "Memory info not available")
    log "Memory status: $memory_info"
    
    # Check running processes
    python_processes=$(ps aux | grep python | grep -v grep | wc -l)
    log "Active Python processes: $python_processes"
    
    # Check network connectivity
    if ping -c 1 google.com >/dev/null 2>&1; then
        log "Network connectivity: OK"
    else
        log "Warning: Network connectivity issues detected"
    fi
    
    log "System health check completed"
}

# Restart services if needed
restart_services() {
    log "Checking services that need restart..."
    
    # Check if income monitoring system is running
    if ! pgrep -f "income_monitor.py" >/dev/null; then
        log "Starting income monitoring system..."
        python "$HOME/workspace/income-systems/autonomous/income_monitor.py" &
    else
        log "Income monitoring system is running"
    fi
    
    # Add other service checks here
    
    log "Service check completed"
}

# Main execution
main() {
    log "==========================================="
    log "Starting automated system maintenance"
    log "==========================================="
    
    backup_data
    update_system
    update_python_packages
    update_nodejs_packages
    update_git_repositories
    clean_temp_files
    check_system_health
    restart_services
    
    log "==========================================="
    log "Automated maintenance completed successfully"
    log "Log file: $LOG_FILE"
    log "==========================================="
}

# Run main function
main
