---
layout: default
title: Available Development Tools
parent: Development
nav_order: 1
permalink: /development/available-tools/
---

# Available Development Tools

Complete overview of development tools and utilities available in NazDocker Lab.

## 🐍 Python Development

### Python 3.x
```bash
# Check Python version
python3 --version

# Install packages with pip
pip3 install package_name

# Create virtual environment
python3 -m venv myenv
source myenv/bin/activate

# Run Python scripts
python3 script.py
```

### Common Python Packages
```bash
# Web development
pip3 install flask django fastapi

# Data science
pip3 install pandas numpy matplotlib seaborn

# Machine learning
pip3 install scikit-learn tensorflow pytorch

# Testing
pip3 install pytest unittest

# Code quality
pip3 install black flake8 pylint
```

## 🟢 Node.js Development

### Node.js and npm
```bash
# Check Node.js version
node --version

# Check npm version
npm --version

# Install packages
npm install package_name

# Install globally
npm install -g package_name

# Run Node.js scripts
node script.js
```

### Common Node.js Packages
```bash
# Web frameworks
npm install express koa fastify

# Build tools
npm install webpack vite parcel

# Testing
npm install jest mocha chai

# Code quality
npm install eslint prettier
```

## 📦 Package Management

### Ubuntu (apt)
```bash
# Update package list
apt-get update

# Install packages
apt-get install -y package_name

# Remove packages
apt-get remove package_name

# Search packages
apt search package_name

# Upgrade packages
apt-get upgrade
```

### Alpine (apk)
```bash
# Update package list
apk update

# Install packages
apk add package_name

# Remove packages
apk del package_name

# Search packages
apk search package_name

# Upgrade packages
apk upgrade
```

## 🔧 System Utilities

### Network Tools
```bash
# Network connectivity
ping google.com
curl -I https://google.com
wget https://example.com/file.txt

# Network configuration
ifconfig
ip addr show
netstat -tulpn

# DNS resolution
nslookup google.com
dig google.com
```

### File Management
```bash
# File operations
ls -la
cp source destination
mv old_name new_name
rm file_name

# Archive operations
tar -czf archive.tar.gz directory/
tar -xzf archive.tar.gz

# File search
find . -name "*.py"
grep "pattern" file.txt
```

### Process Management
```bash
# Process information
ps aux
top
htop

# Process control
kill process_id
pkill process_name
killall process_name
```

## 📝 Text Editors

### Nano (Simple)
```bash
# Edit file
nano filename.txt

# Search in nano
Ctrl + W

# Save and exit
Ctrl + X, then Y, then Enter
```

### Vim (Advanced)
```bash
# Edit file
vim filename.txt

# Vim commands
i          # Insert mode
Esc        # Command mode
:w         # Save
:q         # Quit
:wq        # Save and quit
:q!        # Quit without saving
```

### VS Code (if installed)
```bash
# Install VS Code
apt-get install -y code  # Ubuntu
apk add code             # Alpine

# Open file
code filename.txt

# Open directory
code .
```

## 🔍 Development Utilities

### JSON Processing
```bash
# Install jq
apt-get install -y jq  # Ubuntu
apk add jq             # Alpine

# Process JSON
echo '{"name": "test"}' | jq '.name'
cat data.json | jq '.items[]'
```

### Text Processing
```bash
# Sed for text replacement
sed 's/old/new/g' file.txt

# Awk for text processing
awk '{print $1}' file.txt

# Sort and unique
sort file.txt | uniq
```

### Compression
```bash
# Gzip compression
gzip file.txt
gunzip file.txt.gz

# Zip compression
zip archive.zip file1.txt file2.txt
unzip archive.zip
```

## 🗄️ Version Control

### Git
```bash
# Initialize repository
git init

# Clone repository
git clone https://github.com/user/repo.git

# Add files
git add filename.txt
git add .

# Commit changes
git commit -m "Add new feature"

# Push changes
git push origin main

# Check status
git status
git log --oneline
```

### Git Configuration
```bash
# Set user information
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch
git config --global init.defaultBranch main

# View configuration
git config --list
```

## 🧪 Testing Tools

### Python Testing
```bash
# Run tests with pytest
pytest test_file.py

# Run tests with unittest
python3 -m unittest test_file.py

# Run with coverage
pip3 install coverage
coverage run test_file.py
coverage report
```

### Node.js Testing
```bash
# Run tests with npm
npm test

# Run tests with jest
npx jest

# Run tests with mocha
npx mocha test_file.js
```

## 🔍 Debugging Tools

### Python Debugging
```bash
# Use pdb
python3 -m pdb script.py

# Use ipdb (enhanced pdb)
pip3 install ipdb
python3 -m ipdb script.py
```

### Node.js Debugging
```bash
# Use Node.js debugger
node --inspect script.js

# Use debug module
npm install debug
```

### System Debugging
```bash
# Check system resources
free -h
df -h
top

# Check network
netstat -tulpn
ss -tulpn

# Check processes
ps aux | grep process_name
```

## 📊 Monitoring Tools

### System Monitoring
```bash
# Real-time system stats
htop
top

# Disk usage
du -sh directory/
df -h

# Memory usage
free -h
cat /proc/meminfo
```

### Network Monitoring
```bash
# Network connections
netstat -an
ss -tulpn

# Network traffic
iftop
nethogs
```

## 🔧 Custom Tools Installation

### Installing Additional Tools
```bash
# Development tools
apt-get install -y build-essential cmake  # Ubuntu
apk add build-base cmake                  # Alpine

# Database tools
apt-get install -y mysql-client postgresql-client  # Ubuntu
apk add mysql-client postgresql-client             # Alpine

# Monitoring tools
apt-get install -y htop iotop nethogs  # Ubuntu
apk add htop iotop nethogs             # Alpine
```

### Python Development Environment
```bash
# Install Python development tools
apt-get install -y python3-dev python3-pip  # Ubuntu
apk add python3-dev py3-pip                 # Alpine

# Install common Python packages
pip3 install ipython jupyter notebook
```

### Node.js Development Environment
```bash
# Install Node.js development tools
apt-get install -y nodejs npm  # Ubuntu
apk add nodejs npm             # Alpine

# Install global packages
npm install -g nodemon pm2
```

## 🔗 Related Topics

- **[Container Management](../administration/container-management.md)** - Managing the development environment
- **[Environment Variables](../administration/environment-variables.md)** - Configuration management
- **[User Management](../user-management/user-accounts.md)** - User account management
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common development issues