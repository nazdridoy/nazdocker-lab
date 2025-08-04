# NazDocker Lab - Management Guide

Comprehensive guide for managing and maintaining the NazDocker Lab environment.

## 📋 Table of Contents

- [Quick Reference](#-quick-reference)
- [Environment Configuration](#-environment-configuration)
- [User Management](#-user-management)
- [Security Management](#-security-management)
- [Remote Access](#-remote-access)
- [Backup and Recovery](#-backup-and-recovery)
- [Monitoring and Troubleshooting](#-monitoring-and-troubleshooting)
- [Advanced Configuration](#-advanced-configuration)
- [Maintenance Procedures](#-maintenance-procedures)

## ⚡ Quick Reference

### Essential Commands

#### Ubuntu Version
```bash
# Start the environment
docker-compose up -d

# Stop the environment
docker-compose down

# Restart the environment
docker-compose restart

# View logs
docker-compose logs -f

# Access container shell
docker-compose exec lab-environment-ubuntu bash

# Validate configuration
docker-compose config

# Check container status
docker-compose ps
```

#### Alpine Version (82% smaller)
```bash
# Start the environment
docker-compose -f docker-compose.alpine.yml up -d

# Stop the environment
docker-compose -f docker-compose.alpine.yml down

# Restart the environment
docker-compose -f docker-compose.alpine.yml restart

# View logs
docker-compose -f docker-compose.alpine.yml logs -f

# Access container shell
docker-compose -f docker-compose.alpine.yml exec lab-environment-alpine bash

# Validate configuration
docker-compose -f docker-compose.alpine.yml config

# Check container status
docker-compose -f docker-compose.alpine.yml ps
```

### Container Management

#### Ubuntu Version
```bash
# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View container logs
docker-compose logs lab-environment-ubuntu

# Execute command in container
docker-compose exec lab-environment-ubuntu <command>

# Stop and remove everything
docker-compose down -v --remove-orphans

# Check container health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View detailed health information
docker inspect student-lab | grep -A 20 "Health"
```

#### Alpine Version
```bash
# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View container logs
docker-compose -f docker-compose.alpine.yml logs lab-environment-alpine

# Execute command in container
docker-compose -f docker-compose.alpine.yml exec lab-environment-alpine <command>

# Stop and remove everything
docker-compose -f docker-compose.alpine.yml down -v --remove-orphans

# Check container health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View detailed health information
docker inspect student-lab-alpine | grep -A 20 "Health"
```

## 🔧 Environment Configuration

### Environment Variables Overview

The lab uses environment variables for secure, flexible configuration. This approach:
- Keeps sensitive data out of version control
- Enables easy configuration changes without rebuilding
- Provides a template (`.env.example`) for new deployments

### Setting Up Environment Variables

1. **Copy the template file**:
   ```bash
   cp .env.example .env
   ```

2. **Edit with your values**:
   ```bash
   nano .env
   # or
   vim .env
   ```

### Available Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `PLAYIT_SECRET_KEY` | Playit.gg secret key for public tunneling | - | Yes |
| `ADMIN_PASSWORD` | Password for admin user | `admin123` | No |
| `USER_PASSWORD` | Password for user1-user5 | `user123` | No |
| `ROOT_PASSWORD` | Password for root user | `root123` | No |
| `SSH_PORT` | SSH port mapping | `2222` | No |

### Validating Configuration

```bash
# View resolved configuration
docker-compose config

# Check specific variables
docker-compose config | grep PLAYIT_SECRET_KEY
docker-compose config | grep -E "(ADMIN_PASSWORD|USER_PASSWORD|ROOT_PASSWORD)"

# Validate without starting containers
docker-compose config --quiet

# Export configuration for review
docker-compose config > resolved-config.yml
```

### Security Best Practices

- **Never commit** `.env` files to version control
- **Use strong passwords** for all user accounts
- **Rotate credentials** regularly
- **Use SSH keys** instead of passwords when possible
- **Monitor access logs** for suspicious activity

## 👥 User Management

### User Account Overview

| Username | Default Password | Sudo Access | Purpose |
|----------|------------------|-------------|---------|
| `admin` | `admin123` | ✅ Yes | Administrative tasks |
| `user1` | `user123` | ❌ No | Regular development |
| `user2` | `user123` | ❌ No | Regular development |
| `user3` | `user123` | ❌ No | Regular development |
| `user4` | `user123` | ❌ No | Regular development |
| `user5` | `user123` | ❌ No | Regular development |
| `root` | `root123` | ✅ Yes | System administration |

### Adding New Users

#### Method 1: Container Shell
```bash
# Access container
docker-compose exec lab-environment bash

# Add new user
useradd -m -s /bin/bash newuser
echo "newuser:password123" | chpasswd

# Add to sudo group (optional)
usermod -aG sudo newuser

# Create home directory structure
mkdir -p /home/newuser/{Documents,Downloads,Projects}
chown -R newuser:newuser /home/newuser
```

#### Method 2: Environment Variables
```bash
# Add to .env file
USER_PASSWORD=newpassword123

# Restart container
docker-compose down && docker-compose up -d
```

#### Method 3: Dockerfile Modification
```dockerfile
# Add to Dockerfile
RUN useradd -m -s /bin/bash newuser && \
    echo "newuser:password123" | chpasswd && \
    usermod -aG sudo newuser
```

### Removing Users

```bash
# Access container
docker-compose exec lab-environment bash

# Remove user and home directory
userdel -r username

# Remove from sudo group (if applicable)
gpasswd -d username sudo
```

### Listing Users

```bash
# List all users with shell access
docker-compose exec lab-environment bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

# List users with sudo access
docker-compose exec lab-environment bash -c "
getent group sudo
"

# List all users
docker-compose exec lab-environment bash -c "
cut -d: -f1 /etc/passwd | sort
"
```

### Changing User Passwords

#### Method 1: Interactive (Recommended)
```bash
# Access container
docker-compose exec lab-environment bash

# Change passwords interactively
passwd admin
passwd user1
passwd user2
# ... etc
```

#### Method 2: Environment Variables
```bash
# Edit .env file
ADMIN_PASSWORD=newadminpass
USER_PASSWORD=newuserpass
ROOT_PASSWORD=newrootpass

# Restart container
docker-compose down && docker-compose up -d
```

#### Method 3: Command Line
```bash
# Access container
docker-compose exec lab-environment bash

# Change passwords non-interactively
echo "admin:newpassword" | chpasswd
echo "user1:newpassword" | chpasswd
# ... etc
```

## 🔐 Security Management

### SSH Key Authentication

#### Method 1: Mount SSH Keys
```yaml
# In docker-compose.yml
volumes:
  - ~/.ssh/id_rsa.pub:/home/admin/.ssh/authorized_keys:ro
  - ~/.ssh/id_rsa.pub:/home/user1/.ssh/authorized_keys:ro
```

#### Method 2: Container Shell
```bash
# Access container
docker-compose exec lab-environment bash

# Add SSH key for admin
mkdir -p /home/admin/.ssh
echo "your_public_key_here" >> /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh
chmod 700 /home/admin/.ssh
chmod 600 /home/admin/.ssh/authorized_keys
```

#### Method 3: Dockerfile
```dockerfile
# In Dockerfile
RUN mkdir -p /home/admin/.ssh && \
    echo "your_public_key_here" >> /home/admin/.ssh/authorized_keys && \
    chown -R admin:admin /home/admin/.ssh && \
    chmod 700 /home/admin/.ssh && \
    chmod 600 /home/admin/.ssh/authorized_keys
```

### Firewall Configuration

```bash
# Access container
docker-compose exec lab-environment bash

# Install and configure firewall
apt-get update
apt-get install -y ufw

# Configure firewall rules
ufw allow ssh
ufw allow 22
ufw --force enable

# Check firewall status
ufw status
```

### Security Auditing

```bash
# Check for failed login attempts
docker-compose exec lab-environment bash -c "
grep 'Failed password' /var/log/auth.log
"

# Check SSH configuration
docker-compose exec lab-environment bash -c "
cat /etc/ssh/sshd_config | grep -E '(PasswordAuthentication|PermitRootLogin|PubkeyAuthentication)'
"

# Check user permissions
docker-compose exec lab-environment bash -c "
ls -la /home/
"
```

## 🌐 Remote Access

### Playit.gg Tunnel Management

#### Checking Tunnel Status
```bash
# View tunnel logs
docker-compose logs lab-environment | grep -i "playit\|tunnel\|url"

# Follow logs in real-time
docker-compose logs -f lab-environment

# Check playit.gg process
docker-compose exec lab-environment ps aux | grep playit
```

#### Updating Playit.gg Secret Key

**Method 1: Environment File (Recommended)**
```bash
# Edit .env file
nano .env

# Update the secret key
PLAYIT_SECRET_KEY=your_new_secret_key_here

# Restart container
docker-compose down && docker-compose up -d
```

**Method 2: Environment Variable**
```bash
# Stop container
docker-compose down

# Set environment variable
export PLAYIT_SECRET_KEY=your_new_secret_key_here

# Start with new key
docker-compose up -d
```

**Method 3: Dockerfile**
```dockerfile
# In Dockerfile
ENV PLAYIT_SECRET_KEY=your_secret_key_here
```

#### Troubleshooting Tunnel Issues

```bash
# Check if secret key is loaded
docker-compose exec lab-environment env | grep PLAYIT

# Restart playit.gg service
docker-compose exec lab-environment pkill playit-agent

# Check tunnel connectivity
docker-compose exec lab-environment ping google.com
```

### SSH Service Management

```bash
# Check SSH service status
docker-compose exec lab-environment service ssh status

# Restart SSH service
docker-compose exec lab-environment service ssh restart

# Check SSH configuration
docker-compose exec lab-environment cat /etc/ssh/sshd_config

# Test SSH locally
docker-compose exec lab-environment ssh localhost
```

## 💾 Backup and Recovery

### Backup Strategies

#### User Data Backup
```bash
# Backup all user data
tar -czf lab-backup-$(date +%Y%m%d-%H%M%S).tar.gz data/

# Backup specific user
tar -czf user1-backup-$(date +%Y%m%d-%H%M%S).tar.gz data/user1/

# Backup with compression
tar -czf lab-backup-$(date +%Y%m%d).tar.gz data/ --exclude='*.tmp' --exclude='*.log'
```

#### Configuration Backup
```bash
# Backup Docker configuration
docker-compose config > docker-compose-backup-$(date +%Y%m%d).yml

# Backup Dockerfile
cp Dockerfile Dockerfile.backup-$(date +%Y%m%d)

# Backup environment variables (without sensitive data)
cp .env.example .env.example.backup-$(date +%Y%m%d)
```

#### Complete System Backup
```bash
#!/bin/bash
BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in $BACKUP_DIR..."

# Backup user data
tar -czf "$BACKUP_DIR/user-data.tar.gz" data/

# Backup configuration
cp docker-compose.yml "$BACKUP_DIR/"
cp Dockerfile "$BACKUP_DIR/"
cp .env.example "$BACKUP_DIR/"

# Backup container state
docker-compose ps > "$BACKUP_DIR/container-status.txt"

echo "Backup completed: $BACKUP_DIR"
```

### Restore Procedures

#### Restore User Data
```bash
# Restore all data
tar -xzf lab-backup-20231201-143022.tar.gz

# Restore specific user
tar -xzf user1-backup-20231201-143022.tar.gz

# Verify restoration
ls -la data/
```

#### Restore Configuration
```bash
# Restore Docker Compose configuration
cp docker-compose-backup-20231201.yml docker-compose.yml

# Restore Dockerfile
cp Dockerfile.backup-20231201 Dockerfile

# Rebuild container
docker-compose up -d --build
```

### Automated Backup Script

```bash
#!/bin/bash
# backup-lab.sh

BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting backup at $(date)..."

# Stop container to ensure data consistency
docker-compose stop

# Backup user data
tar -czf "$BACKUP_DIR/user-data.tar.gz" data/

# Backup configuration
cp docker-compose.yml "$BACKUP_DIR/"
cp Dockerfile "$BACKUP_DIR/"

# Start container
docker-compose start

echo "Backup completed: $BACKUP_DIR"
```

## 📊 Monitoring and Troubleshooting

### Container Monitoring

#### Status Checks

##### Ubuntu Version
```bash
# Check container status
docker-compose ps

# Check resource usage
docker stats lab-environment

# Check container logs
docker-compose logs lab-environment

# Check container health
docker-compose exec lab-environment systemctl status ssh

# Monitor health check status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View health check configuration
docker inspect student-lab | grep -A 10 "Healthcheck"
```

##### Alpine Version
```bash
# Check container status
docker-compose -f docker-compose.alpine.yml ps

# Check resource usage
docker stats student-lab-alpine

# Check container logs
docker-compose -f docker-compose.alpine.yml logs lab-environment

# Check container health
docker-compose -f docker-compose.alpine.yml exec lab-environment pgrep sshd

# Monitor health check status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View health check configuration
docker inspect student-lab-alpine | grep -A 10 "Healthcheck"
```

#### Resource Monitoring
```bash
# Monitor CPU and memory usage
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

# Check disk usage
docker-compose exec lab-environment df -h

# Check memory usage
docker-compose exec lab-environment free -h
```

### Troubleshooting Common Issues

#### Environment Variable Issues
```bash
# Check if .env file exists
ls -la .env

# Verify .env file syntax
cat .env | grep -v "^#" | grep -v "^$"

# Check if variables are loaded
docker-compose config | grep -E "(PLAYIT_SECRET_KEY|ADMIN_PASSWORD|USER_PASSWORD|ROOT_PASSWORD)"

# Test environment variable loading
docker-compose config --quiet

# Recreate .env file if corrupted
cp .env.example .env
```

#### Container Won't Start
```bash
# Check logs
docker-compose logs

# Check disk space
df -h

# Check Docker daemon
sudo systemctl status docker

# Check Docker Compose version
docker-compose --version
```

#### SSH Connection Issues
```bash
# Check if container is running
docker-compose ps

# Check SSH service
docker-compose exec lab-environment service ssh status

# Check port mapping
docker port lab-environment

# Test SSH locally
docker-compose exec lab-environment ssh localhost

# Check health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View health check logs
docker inspect student-lab | grep -A 20 "Health"
```

#### Network Connectivity Issues
```bash
# Test network connectivity
docker-compose exec lab-environment ping google.com

# Check network interfaces
docker-compose exec lab-environment ifconfig

# Check DNS resolution
docker-compose exec lab-environment nslookup google.com
```

### Health Monitoring

#### Health Check Overview
The container includes built-in health checks that monitor SSH service availability:

- **Interval**: 30 seconds between checks
- **Timeout**: 10 seconds maximum for each check
- **Start Period**: 40 seconds grace period after container startup
- **Retries**: 3 consecutive failures before marking as unhealthy

#### Health Status Monitoring
```bash
# Check container health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View detailed health information
docker inspect student-lab | grep -A 20 "Health"

# Monitor health check logs
docker inspect student-lab | grep -A 10 "Healthcheck"

# Test health check manually
docker-compose exec lab-environment service ssh status
```

#### Health Check Troubleshooting
```bash
# If container shows as unhealthy
docker-compose exec lab-environment service ssh status

# Restart SSH service if needed
docker-compose exec lab-environment service ssh restart

# Check SSH configuration
docker-compose exec lab-environment cat /etc/ssh/sshd_config

# View health check logs
docker inspect student-lab | grep -A 20 "Health"
```

### Log Analysis

#### SSH Logs
```bash
# View SSH access logs
docker-compose exec lab-environment tail -f /var/log/auth.log

# Check failed login attempts
docker-compose exec lab-environment grep "Failed password" /var/log/auth.log

# Check successful logins
docker-compose exec lab-environment grep "Accepted password" /var/log/auth.log
```

#### System Logs
```bash
# View system logs
docker-compose exec lab-environment journalctl -f

# Check service status
docker-compose exec lab-environment systemctl status --all
```

## ⚙️ Advanced Configuration

### Startup Script Management

The lab environment uses a modularized startup script (`start.sh`) that handles:
- User account creation and password management
- SSH service initialization
- Playit.gg tunnel setup
- Home directory permissions

#### Modifying the Startup Script
```bash
# Edit the startup script
nano start.sh

# Rebuild container after changes
docker-compose up -d --build

# View startup script logs
docker-compose logs lab-environment | grep -i "start\|ssh\|playit"
```

#### Startup Script Functions
- **User Management**: Creates and configures all user accounts
- **Password Configuration**: Sets passwords from environment variables
- **SSH Setup**: Starts and configures SSH service
- **Tunnel Management**: Initializes playit.gg tunneling
- **Service Monitoring**: Keeps container running with health checks

### Customizing the Container

#### Adding Additional Packages
```bash
# Method 1: Running container
docker-compose exec lab-environment bash
apt-get update
apt-get install -y package_name

# Method 2: Dockerfile modification
# Add to Dockerfile
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*
```

#### Custom Scripts
```bash
# Create custom installation script
cat > install-tools.sh << 'EOF'
#!/bin/bash
apt-get update
apt-get install -y htop vim nano
EOF

# Copy to container and execute
docker cp install-tools.sh lab-environment:/tmp/
docker-compose exec lab-environment bash /tmp/install-tools.sh
```

### Performance Optimization

#### Resource Limits
```yaml
# In docker-compose.yml
services:
  lab-environment:
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

#### Volume Optimization
```yaml
# In docker-compose.yml
volumes:
  - ./data:/home:delegated
  - ./logs:/var/log:delegated
```

### Network Configuration

#### Custom Network
```yaml
# In docker-compose.yml
networks:
  lab-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

services:
  lab-environment:
    networks:
      - lab-network
```

## 🔧 Maintenance Procedures

### Regular Maintenance Tasks

#### Weekly Tasks
```bash
# Update package lists
docker-compose exec lab-environment apt-get update

# Check for security updates
docker-compose exec lab-environment apt-get upgrade --dry-run

# Clean up old packages
docker-compose exec lab-environment apt-get autoremove -y
```

#### Monthly Tasks
```bash
# Full system update
docker-compose exec lab-environment apt-get update && apt-get upgrade -y

# Rebuild container with updated base image
docker-compose up -d --build

# Review and rotate logs
docker-compose exec lab-environment find /var/log -name "*.log" -mtime +30 -delete
```

#### Quarterly Tasks
```bash
# Security audit
docker-compose exec lab-environment apt-get audit

# Review user accounts
docker-compose exec lab-environment cat /etc/passwd | grep -E ":(/bin/bash|/bin/sh)$"

# Update SSH keys
# Review and update authorized_keys files
```

### Emergency Procedures

#### Container Reset
```bash
# Stop and remove container
docker-compose down

# Remove volumes (WARNING: Deletes all data)
docker-compose down -v

# Rebuild and start
docker-compose up -d --build
```

#### Emergency Access
```bash
# Access container when SSH is down
docker-compose exec lab-environment bash

# Check SSH service
service ssh status

# Restart SSH if needed
service ssh restart
```

#### Emergency Backup
```bash
# Quick backup before emergency procedures
docker cp lab-environment:/home ./emergency-backup-$(date +%Y%m%d-%H%M%S)

# Backup configuration
cp docker-compose.yml ./emergency-backup-$(date +%Y%m%d-%H%M%S)-config.yml
```

### Cleanup Procedures

#### Complete Cleanup
```bash
# Stop and remove everything
docker-compose down -v --remove-orphans --rmi all

# Remove all unused Docker resources
docker system prune -a --volumes

# Verify cleanup
docker ps -a
docker network ls
docker volume ls
docker images
```

#### Selective Cleanup
```bash
# Remove specific resources
docker rm -f lab-environment
docker network rm nazdocker-lab_lab-network
docker volume rm nazdocker-lab_user-data
```

## 📝 Useful Scripts

### Status Check Script
```bash
#!/bin/bash
# status-check.sh

echo "=== NazDocker Lab Status ==="
echo "Container Status:"
docker-compose ps
echo ""

echo "Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "Recent Logs:"
docker-compose logs --tail=20 lab-environment
echo ""

echo "Resource Usage:"
docker stats --no-stream lab-environment
echo ""

echo "User Accounts:"
docker-compose exec lab-environment bash -c "cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'"
```

### Alpine Status Check Script
```bash
#!/bin/bash
# status-check-alpine.sh

echo "=== NazDocker Lab Alpine Status ==="
echo "Container Status:"
docker-compose -f docker-compose.alpine.yml ps
echo ""

echo "Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "Recent Logs:"
docker-compose -f docker-compose.alpine.yml logs --tail=20 lab-environment
echo ""

echo "Resource Usage:"
docker stats --no-stream student-lab-alpine
echo ""

echo "User Accounts:"
docker-compose -f docker-compose.alpine.yml exec lab-environment bash -c "cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'"
```

### User Management Script
```bash
#!/bin/bash
# user-management.sh

ACTION=$1
USERNAME=$2

case $ACTION in
    "add")
        docker-compose exec lab-environment bash -c "
            useradd -m -s /bin/bash $USERNAME
            echo '$USERNAME:password123' | chpasswd
            echo 'User $USERNAME created with password: password123'
        "
        ;;
    "remove")
        docker-compose exec lab-environment bash -c "
            userdel -r $USERNAME
            echo 'User $USERNAME removed'
        "
        ;;
    "list")
        docker-compose exec lab-environment bash -c "
            cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
        "
        ;;
    *)
        echo "Usage: $0 {add|remove|list} [username]"
        ;;
esac
```

### Health Monitoring Script
```bash
#!/bin/bash
# health-monitor.sh

echo "=== NazDocker Lab Health Monitor ==="
echo ""

echo "Container Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "Detailed Health Information:"
docker inspect student-lab | grep -A 20 "Health"
echo ""

echo "SSH Service Status:"
docker-compose exec lab-environment service ssh status
echo ""

echo "Recent Health Check Logs:"
docker inspect student-lab | grep -A 10 "Healthcheck"
```

### Backup Script
```bash
#!/bin/bash
# backup-lab.sh

BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in $BACKUP_DIR..."

# Backup user data
tar -czf "$BACKUP_DIR/user-data.tar.gz" data/

# Backup configuration
cp docker-compose.yml "$BACKUP_DIR/"
cp Dockerfile "$BACKUP_DIR/"
cp start.sh "$BACKUP_DIR/"

# Backup container state
docker-compose ps > "$BACKUP_DIR/container-status.txt"

echo "Backup completed: $BACKUP_DIR"
```

### Alpine Backup Script
```bash
#!/bin/bash
# backup-lab-alpine.sh

BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)-alpine"
mkdir -p "$BACKUP_DIR"

echo "Creating Alpine backup in $BACKUP_DIR..."

# Backup user data
tar -czf "$BACKUP_DIR/user-data.tar.gz" data/

# Backup configuration
cp docker-compose.alpine.yml "$BACKUP_DIR/"
cp Dockerfile.alpine "$BACKUP_DIR/"
cp start.sh "$BACKUP_DIR/"

# Backup container state
docker-compose -f docker-compose.alpine.yml ps > "$BACKUP_DIR/container-status.txt"

echo "Alpine backup completed: $BACKUP_DIR"
```

## 📁 Project Structure

```
nazdocker-lab/
├── Dockerfile              # Ubuntu container definition with health checks
├── Dockerfile.alpine       # Alpine container definition (173MB)
├── start.sh               # Cross-platform startup script
├── docker-compose.yml      # Ubuntu Docker Compose orchestration
├── docker-compose.alpine.yml # Alpine Docker Compose orchestration
├── .env.example           # Environment variables template
├── README.md              # Project documentation
├── MANAGEMENT.md          # This management guide
├── LICENSE                # GPL v3 license
├── data/                  # Persistent user data
│   ├── admin/            # Admin home directory
│   ├── user1/            # User1 home directory
│   ├── user2/            # User2 home directory
│   ├── user3/            # User3 home directory
│   ├── user4/            # User4 home directory
│   └── user5/            # User5 home directory
└── logs/                 # Application logs
```

### Key Files Explained

- **`Dockerfile`**: Ubuntu container definition with health checks and user setup
- **`Dockerfile.alpine`**: Alpine container definition (82% smaller, 173MB)
- **`start.sh`**: Cross-platform startup script for runtime configuration
- **`docker-compose.yml`**: Ubuntu orchestration and volume management
- **`docker-compose.alpine.yml`**: Alpine orchestration and volume management
- **`.env.example`**: Template for environment variable configuration
- **`data/`**: Persistent storage for user home directories
- **`logs/`**: Application and service logs

## 🏔️ Alpine vs Ubuntu Comparison

### Image Size Comparison
| Version | Base Image | Final Size | Size Reduction |
|---------|------------|------------|----------------|
| **Ubuntu** | `ubuntu:24.04` | 1.05GB | - |
| **Alpine** | `alpine:3.22` | 189MB | **82% smaller** |

### Performance Benefits
- **Build Time**: Alpine builds ~50% faster
- **Startup Time**: Alpine starts ~30% faster
- **Memory Usage**: Alpine uses ~40% less memory
- **Disk Space**: Alpine saves 861MB per container

### Resource Limits
Both versions are configured with optimized resource limits:
- **CPU**: Maximum 2 cores, minimum 1 core reserved
- **Memory**: Maximum 2GB, minimum 1GB reserved
- **Network**: Standard bridge networking
- **Storage**: Persistent volumes for user data

### When to Use Each Version

**Use Alpine When:**
- Resource constraints are a concern
- Fast deployments are needed
- Security is a priority (smaller attack surface)
- Production environments where size matters

**Use Ubuntu When:**
- Maximum compatibility is needed
- Familiar environment is preferred
- Specific Ubuntu packages are required
- Development/testing environments

### Key Technical Differences
- **Package Management**: `apt` (Ubuntu) vs `apk` (Alpine)
- **Service Management**: `service` (Ubuntu) vs direct commands (Alpine)
- **User Groups**: `sudo` (Ubuntu) vs `wheel` (Alpine)
- **Health Checks**: `service ssh status` (Ubuntu) vs `pgrep sshd` (Alpine)

---

**Note**: This management guide is designed for administrators and advanced users. Always follow security best practices and test procedures in a safe environment before applying to production systems. 