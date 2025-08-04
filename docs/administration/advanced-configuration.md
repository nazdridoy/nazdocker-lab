---
layout: default
title: Advanced Configuration
parent: Administration
nav_order: 5
permalink: /administration/advanced-configuration/
---

# Advanced Configuration

Complete guide for advanced configuration and customization of NazDocker Lab.

## ⚙️ Startup Script Management

The lab environment uses a modularized startup script (`start.sh`) that handles:
- User account creation and password management
- SSH service initialization
- Playit.gg tunnel setup
- Home directory permissions

### Modifying the Startup Script
```bash
# Edit the startup script
nano start.sh

# Rebuild container after changes
docker-compose -f docker-compose.ubuntu.yml up -d --build

# View startup script logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "start\|ssh\|playit"
```

### Startup Script Functions
- **User Management**: Creates and configures all user accounts
- **Password Configuration**: Sets passwords from environment variables
- **SSH Setup**: Starts and configures SSH service
- **Tunnel Management**: Initializes playit.gg tunneling
- **Service Monitoring**: Keeps container running with health checks

### Startup Script Analysis
```bash
# View startup script
cat start.sh

# Check startup script permissions
ls -la start.sh

# Test startup script syntax
bash -n start.sh

# Run startup script manually (for testing)
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash /start.sh
```

## 🔧 Customizing the Container

### Adding Additional Packages

#### Method 1: Running Container
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Update package list
apt-get update

# Install packages
apt-get install -y package_name

# Clean up
apt-get autoremove -y
apt-get clean
```

#### Method 2: Dockerfile Modification
```dockerfile
# Add to Dockerfile.ubuntu
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*
```

#### Method 3: Custom Installation Script
```bash
# Create custom installation script
cat > install-tools.sh << 'EOF'
#!/bin/bash
apt-get update
apt-get install -y htop vim nano curl wget git
apt-get autoremove -y
apt-get clean
EOF

# Copy to container and execute
docker cp install-tools.sh student-lab-ubuntu:/tmp/
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash /tmp/install-tools.sh

# Make script executable
chmod +x install-tools.sh
```

### Custom Scripts

#### Development Tools Installation
```bash
# Create development tools script
cat > install-dev-tools.sh << 'EOF'
#!/bin/bash
echo "Installing development tools..."

# Python development
apt-get update
apt-get install -y python3-dev python3-pip python3-venv

# Node.js development
apt-get install -y nodejs npm

# Build tools
apt-get install -y build-essential cmake

# Development utilities
apt-get install -y git vim nano htop curl wget

# Clean up
apt-get autoremove -y
apt-get clean

echo "Development tools installation completed"
EOF

# Execute script
docker cp install-dev-tools.sh student-lab-ubuntu:/tmp/
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash /tmp/install-dev-tools.sh
```

#### Security Tools Installation
```bash
# Create security tools script
cat > install-security-tools.sh << 'EOF'
#!/bin/bash
echo "Installing security tools..."

# Security utilities
apt-get update
apt-get install -y fail2ban ufw auditd

# Monitoring tools
apt-get install -y htop iotop nethogs

# Network tools
apt-get install -y net-tools nmap tcpdump

# Clean up
apt-get autoremove -y
apt-get clean

echo "Security tools installation completed"
EOF

# Execute script
docker cp install-security-tools.sh student-lab-ubuntu:/tmp/
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash /tmp/install-security-tools.sh
```

## 📈 Performance Optimization

### Resource Limits

#### Docker Compose Resource Configuration
```yaml
# In docker-compose.ubuntu.yml
services:
  lab-environment-ubuntu:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
        reservations:
          cpus: '1.0'
          memory: 1G
```

**Current Configuration:**
- **CPU Limits**: Maximum 2 cores, minimum 1 core reserved
- **Memory Limits**: Maximum 2GB, minimum 1GB reserved
- **Network**: Standard bridge networking
- **Storage**: Persistent volumes for user data

#### Custom Resource Limits
```yaml
# Custom resource configuration
services:
  lab-environment-ubuntu:
    deploy:
      resources:
        limits:
          cpus: '4.0'      # 4 CPU cores
          memory: 4G        # 4GB RAM
        reservations:
          cpus: '2.0'       # 2 CPU cores reserved
          memory: 2G        # 2GB RAM reserved
```

### Volume Optimization

#### Optimized Volume Configuration
```yaml
# In docker-compose.ubuntu.yml
volumes:
  - ./data:/home:delegated
  - ./logs:/var/log:delegated
  - ./config:/etc/ssh:ro
```

#### Volume Performance Options
```yaml
# Performance-optimized volumes
volumes:
  - ./data:/home:cached      # For read-heavy workloads
  - ./logs:/var/log:delegated # For write-heavy workloads
  - ./config:/etc/ssh:ro     # Read-only configuration
```

### Container Optimization

#### Multi-stage Build Optimization
```dockerfile
# Optimized Dockerfile
FROM ubuntu:24.04 as base

# Install essential packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create users
RUN useradd -m -s /bin/bash admin && \
    echo "admin:admin123" | chpasswd && \
    usermod -aG sudo admin

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD service ssh status || exit 1

# Expose SSH port
EXPOSE 22

# Start services
CMD ["/start.sh"]
```

## 🌐 Network Configuration

### Custom Network Setup

#### Bridge Network Configuration
```yaml
# In docker-compose.ubuntu.yml
networks:
  lab-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

services:
  lab-environment-ubuntu:
    networks:
      - lab-network
```

#### Advanced Network Configuration
```yaml
# Advanced network setup
networks:
  lab-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
          gateway: 172.20.0.1
    driver_opts:
      com.docker.network.bridge.name: lab-bridge
    labels:
      - "com.example.some-label=some-value"

services:
  lab-environment-ubuntu:
    networks:
      lab-network:
        ipv4_address: 172.20.0.10
```

### Network Security

#### Firewall Configuration
```bash
# Configure UFW firewall
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 22
ufw --force enable
"

# Check firewall status
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ufw status verbose
```

#### Network Isolation
```yaml
# Isolated network configuration
networks:
  lab-network:
    driver: bridge
    internal: true  # No external connectivity
    ipam:
      config:
        - subnet: 172.20.0.0/16

services:
  lab-environment-ubuntu:
    networks:
      - lab-network
    # Add external network for internet access
    networks:
      - lab-network
      - default
```

## 🔧 Advanced Customization

### Environment-Specific Configuration

#### Development Environment
```yaml
# Development-specific configuration
services:
  lab-environment-ubuntu:
    environment:
      - NODE_ENV=development
      - DEBUG=true
      - LOG_LEVEL=debug
    volumes:
      - ./data:/home
      - ./logs:/var/log
      - ./dev-config:/etc/dev:ro
```

#### Production Environment
```yaml
# Production-specific configuration
services:
  lab-environment-ubuntu:
    environment:
      - NODE_ENV=production
      - DEBUG=false
      - LOG_LEVEL=warn
    deploy:
      resources:
        limits:
          cpus: '4.0'
          memory: 4G
    volumes:
      - ./data:/home
      - ./logs:/var/log
      - ./prod-config:/etc/prod:ro
```

### Custom Health Checks

#### Advanced Health Check
```dockerfile
# Custom health check script
COPY health-check.sh /health-check.sh
RUN chmod +x /health-check.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD /health-check.sh
```

#### Health Check Script
```bash
#!/bin/bash
# health-check.sh

# Check SSH service
if ! service ssh status > /dev/null 2>&1; then
    exit 1
fi

# Check SSH process
if ! pgrep sshd > /dev/null; then
    exit 1
fi

# Check network connectivity
if ! ping -c 1 google.com > /dev/null 2>&1; then
    exit 1
fi

# Check disk space
if [ $(df / | tail -1 | awk '{print $5}' | sed 's/%//') -gt 90 ]; then
    exit 1
fi

exit 0
```

## 📊 Performance Monitoring

### Resource Monitoring Script
```bash
#!/bin/bash
# performance-monitor.sh

echo "=== Performance Monitor ==="
echo ""

echo "1. Container Stats:"
docker stats --no-stream student-lab-ubuntu
echo ""

echo "2. System Resources:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'CPU Usage:'
top -bn1 | grep 'Cpu(s)'
echo 'Memory Usage:'
free -h
echo 'Disk Usage:'
df -h
"
echo ""

echo "3. Network Stats:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
netstat -i
"
echo ""

echo "4. Process List:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
ps aux --sort=-%cpu | head -10
"
echo ""
```

### Optimization Scripts

#### Performance Tuning Script
```bash
#!/bin/bash
# performance-tuning.sh

echo "=== Performance Tuning ==="
echo ""

echo "1. Updating package lists..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get update

echo "2. Installing performance tools..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get install -y htop iotop nethogs

echo "3. Optimizing system settings..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
# Optimize memory settings
echo 'vm.swappiness=10' >> /etc/sysctl.conf

# Optimize disk I/O
echo 'vm.dirty_ratio=15' >> /etc/sysctl.conf
echo 'vm.dirty_background_ratio=5' >> /etc/sysctl.conf
"

echo "4. Cleaning up..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get autoremove -y
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get clean

echo "Performance tuning completed"
```

## 🔗 Related Topics

- **[Container Management](container-management.md)** - Basic container operations
- **[Environment Variables](environment-variables.md)** - Configuration management
- **[Health Monitoring](health-monitoring.md)** - System health monitoring
- **[Backup and Recovery](backup-recovery.md)** - Data backup and restoration
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common configuration issues