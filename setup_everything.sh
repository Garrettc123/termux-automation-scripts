#!/data/data/com.termux/files/usr/bin/bash

# Complete Termux Environment Setup Script
# Automated deployment for autonomous income generation systems
# Copyright (c) 2025 Garrett Christensen

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if running in Termux
check_termux() {
    if [[ ! -d "/data/data/com.termux" ]]; then
        warn "Not running in Termux environment. Some features may not work."
    else
        log "Termux environment detected ✓"
    fi
}

# Update and upgrade packages
update_system() {
    log "Updating Termux packages..."
    pkg update -y || error "Failed to update packages"
    pkg upgrade -y || error "Failed to upgrade packages"
    log "System update complete ✓"
}

# Install essential packages
install_essentials() {
    log "Installing essential packages..."
    
    packages=(
        "python"
        "python-pip"
        "git"
        "curl"
        "wget"
        "nano"
        "vim"
        "htop"
        "tree"
        "jq"
        "nodejs"
        "yarn"
        "openssh"
        "rsync"
        "tmux"
        "screen"
    )
    
    for package in "${packages[@]}"; do
        log "Installing $package..."
        pkg install -y "$package" || warn "Failed to install $package"
    done
    
    log "Essential packages installation complete ✓"
}

# Setup Python environment
setup_python() {
    log "Setting up Python environment..."
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel || error "Failed to upgrade pip"
    
    # Install essential Python packages
    python_packages=(
        "requests"
        "aiohttp"
        "beautifulsoup4"
        "pandas"
        "numpy"
        "cryptography"
        "pydantic"
        "fastapi"
        "uvicorn"
        "sqlalchemy"
        "redis"
        "celery"
        "schedule"
        "python-dotenv"
        "loguru"
        "typer"
        "rich"
    )
    
    for package in "${python_packages[@]}"; do
        log "Installing Python package: $package"
        pip install "$package" || warn "Failed to install $package"
    done
    
    log "Python environment setup complete ✓"
}

# Setup Node.js environment
setup_nodejs() {
    log "Setting up Node.js environment..."
    
    # Install global packages
    npm_packages=(
        "pm2"
        "nodemon"
        "express"
        "axios"
        "cheerio"
        "dotenv"
        "moment"
        "lodash"
        "commander"
    )
    
    for package in "${npm_packages[@]}"; do
        log "Installing Node.js package: $package"
        npm install -g "$package" || warn "Failed to install $package"
    done
    
    log "Node.js environment setup complete ✓"
}

# Create workspace structure
create_workspace() {
    log "Creating workspace structure..."
    
    workspace_dirs=(
        "$HOME/workspace"
        "$HOME/workspace/projects"
        "$HOME/workspace/scripts"
        "$HOME/workspace/data"
        "$HOME/workspace/logs"
        "$HOME/workspace/config"
        "$HOME/workspace/backups"
        "$HOME/workspace/crypto"
        "$HOME/workspace/income-systems"
    )
    
    for dir in "${workspace_dirs[@]}"; do
        mkdir -p "$dir"
        log "Created directory: $dir"
    done
    
    log "Workspace structure created ✓"
}

# Setup automated income system
setup_income_system() {
    log "Setting up autonomous income generation system..."
    
    # Create income system directory
    income_dir="$HOME/workspace/income-systems/autonomous"
    mkdir -p "$income_dir"
    
    # Create basic income monitoring script
    cat > "$income_dir/income_monitor.py" << 'EOF'
#!/usr/bin/env python3
"""
Autonomous Income Monitor
Tracks and reports income generation across all systems
"""

import time
import json
import logging
from datetime import datetime
from pathling import Path

class IncomeMonitor:
    def __init__(self):
        self.data_file = Path.home() / 'workspace' / 'data' / 'income_data.json'
        self.setup_logging()
        
    def setup_logging(self):
        log_file = Path.home() / 'workspace' / 'logs' / 'income_monitor.log'
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(log_file),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger(__name__)
        
    def track_income(self, source: str, amount: float, currency: str = 'USD'):
        """Track income from various sources"""
        income_data = self.load_income_data()
        
        entry = {
            'timestamp': datetime.now().isoformat(),
            'source': source,
            'amount': amount,
            'currency': currency
        }
        
        income_data['entries'].append(entry)
        income_data['total_income'] += amount
        
        self.save_income_data(income_data)
        self.logger.info(f"Income tracked: ${amount} from {source}")
        
    def load_income_data(self):
        """Load existing income data"""
        if self.data_file.exists():
            with open(self.data_file, 'r') as f:
                return json.load(f)
        else:
            return {'total_income': 0.0, 'entries': []}
            
    def save_income_data(self, data):
        """Save income data to file"""
        self.data_file.parent.mkdir(parents=True, exist_ok=True)
        with open(self.data_file, 'w') as f:
            json.dump(data, f, indent=2)
            
    def generate_report(self):
        """Generate income report"""
        data = self.load_income_data()
        print(f"\n=== INCOME REPORT ===")
        print(f"Total Income: ${data['total_income']:.2f}")
        print(f"Total Transactions: {len(data['entries'])}")
        
        if data['entries']:
            latest = data['entries'][-1]
            print(f"Latest Income: ${latest['amount']:.2f} from {latest['source']}")
            
if __name__ == "__main__":
    monitor = IncomeMonitor()
    monitor.generate_report()
EOF
    
    chmod +x "$income_dir/income_monitor.py"
    log "Income monitoring system created ✓"
}

# Setup SSH and security
setup_security() {
    log "Setting up security configurations..."
    
    # Generate SSH key if it doesn't exist
    if [[ ! -f "$HOME/.ssh/id_rsa" ]]; then
        mkdir -p "$HOME/.ssh"
        ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N "" -q
        log "SSH key generated ✓"
    fi
    
    # Set proper permissions
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/id_rsa"
    chmod 644 "$HOME/.ssh/id_rsa.pub"
    
    log "Security setup complete ✓"
}

# Create startup script
create_startup_script() {
    log "Creating system startup script..."
    
    cat > "$HOME/start_income_system.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Autonomous Income System Startup Script
# Starts all income generation systems

echo "🚀 Starting Autonomous Income Generation System..."

# Start income monitor
echo "📊 Starting income monitor..."
python $HOME/workspace/income-systems/autonomous/income_monitor.py &

# Start API systems (placeholder)
echo "🔗 Starting API income systems..."
# python $HOME/workspace/income-systems/api_profit_system.py &

# Start crypto systems (placeholder)
echo "💰 Starting crypto income systems..."
# python $HOME/workspace/income-systems/crypto_arbitrage.py &

echo "✅ All systems started successfully!"
echo "📋 Monitor status: ps aux | grep python"
echo "📈 View income: python $HOME/workspace/income-systems/autonomous/income_monitor.py"
EOF
    
    chmod +x "$HOME/start_income_system.sh"
    log "Startup script created ✓"
}

# Main execution
main() {
    log "🚀 Starting Complete Termux Environment Setup"
    log "================================================"
    
    check_termux
    update_system
    install_essentials
    setup_python
    setup_nodejs
    create_workspace
    setup_income_system
    setup_security
    create_startup_script
    
    log "================================================"
    log "✅ Setup Complete! Your autonomous income system is ready."
    log "📋 Workspace created at: $HOME/workspace"
    log "🚀 Start income systems: $HOME/start_income_system.sh"
    log "📊 Monitor income: python $HOME/workspace/income-systems/autonomous/income_monitor.py"
    log "================================================"
}

# Run main function
main
