---
layout: default
title: Useful Scripts
parent: Administration
nav_order: 6
permalink: /administration/useful-scripts/
---

# Useful Scripts

Complete collection of useful scripts for managing NazDocker Lab.

## 📊 Status Check Scripts

### Ubuntu Status Check Script
```bash
#!/bin/bash
# status-check.sh

echo "=== NazDocker Lab Status ==="
echo "Container Status:"
docker-compose -f docker-compose.ubuntu.yml ps
echo ""

echo "Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "Recent Logs:"
docker-compose -f docker-compose.ubuntu.yml logs --tail=20 lab-environment-ubuntu
echo ""

echo "Resource Usage:"
docker stats --no-stream student-lab-ubuntu
echo ""

echo "User Accounts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'"
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
docker-compose -f docker-compose.alpine.yml logs --tail=20 lab-environment-alpine
echo ""

echo "Resource Usage:"
docker stats --no-stream student-lab-alpine
echo ""

echo "User Accounts:"
docker-compose -f docker-compose.alpine.yml exec lab-environment-alpine bash -c "cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'"
```

## 👥 User Management Scripts

### User Management Script
```bash
#!/bin/bash
# user-management.sh

ACTION=$1
USERNAME=$2

case $ACTION in
    "add")
        docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
            useradd -m -s /bin/bash $USERNAME
            echo '$USERNAME:password123' | chpasswd
            echo 'User $USERNAME created with password: password123'
        "
        ;;
    "remove")
        docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
            userdel -r $USERNAME
            echo 'User $USERNAME removed'
        "
        ;;
    "list")
        docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
            cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
        "
        ;;
    "password")
        docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
            echo '$USERNAME:newpassword123' | chpasswd
            echo 'Password for $USERNAME changed to: newpassword123'
        "
        ;;
    *)
        echo "Usage: $0 {add|remove|list|password} [username]"
        echo "Examples:"
        echo "  $0 add newuser"
        echo "  $0 remove olduser"
        echo "  $0 list"
        echo "  $0 password username"
        ;;
esac
```

### User Status Script
```bash
#!/bin/bash
# user-status.sh

echo "=== User Account Status ==="
echo ""

echo "Users with shell access:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"
echo ""

echo "Users with sudo access:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
getent group sudo
"
echo ""

echo "Home directory usage:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
du -sh /home/* | sort -hr
"
echo ""

echo "Recent login activity:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
tail -10 /var/log/auth.log | grep -E '(Accepted|Failed)'
"
```

## 🏥 Health Monitoring Scripts

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
docker inspect student-lab-ubuntu | grep -A 20 "Health"
echo ""

echo "SSH Service Status:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
echo ""

echo "Recent Health Check Logs:"
docker inspect student-lab-ubuntu | grep -A 10 "Healthcheck"
```

### Comprehensive Health Check
```bash
#!/bin/bash
# comprehensive-health-check.sh

echo "=== Comprehensive Health Check ==="
echo ""

echo "1. Container Status:"
docker-compose -f docker-compose.ubuntu.yml ps
echo ""

echo "2. Health Details:"
docker inspect student-lab-ubuntu | grep -A 20 "Health"
echo ""

echo "3. SSH Service:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
echo ""

echo "4. Network Connectivity:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping -c 1 google.com
echo ""

echo "5. User Accounts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'"
echo ""

echo "6. Recent SSH Logs:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -5 /var/log/auth.log
echo ""

echo "7. Resource Usage:"
docker stats --no-stream student-lab-ubuntu
echo ""

echo "8. Disk Usage:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h
echo ""
```

## 💾 Backup Scripts

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
cp docker-compose.ubuntu.yml "$BACKUP_DIR/"
cp Dockerfile.ubuntu "$BACKUP_DIR/"
cp start.sh "$BACKUP_DIR/"

# Backup container state
docker-compose -f docker-compose.ubuntu.yml ps > "$BACKUP_DIR/container-status.txt"

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

### Automated Backup Script
```bash
#!/bin/bash
# automated-backup.sh

BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting automated backup at $(date)..."

# Stop container to ensure data consistency
docker-compose -f docker-compose.ubuntu.yml stop

# Backup user data
tar -czf "$BACKUP_DIR/user-data.tar.gz" data/

# Backup configuration
cp docker-compose.ubuntu.yml "$BACKUP_DIR/"
cp Dockerfile.ubuntu "$BACKUP_DIR/"
cp start.sh "$BACKUP_DIR/"

# Start container
docker-compose -f docker-compose.ubuntu.yml start

echo "Automated backup completed: $BACKUP_DIR"
```

## 🔍 Diagnostic Scripts

### Quick Diagnostic Script
```bash
#!/bin/bash
# quick-diagnostic.sh

echo "=== Quick Diagnostic ==="
echo ""

echo "1. Container Status:"
docker-compose -f docker-compose.ubuntu.yml ps
echo ""

echo "2. Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "3. Recent Logs:"
docker-compose -f docker-compose.ubuntu.yml logs --tail=10 lab-environment-ubuntu
echo ""

echo "4. Resource Usage:"
docker stats --no-stream student-lab-ubuntu
echo ""

echo "5. SSH Service:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
echo ""

echo "6. Network Connectivity:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping -c 1 google.com
echo ""
```

### Comprehensive Diagnostic Script
```bash
#!/bin/bash
# comprehensive-diagnostic.sh

echo "=== Comprehensive Diagnostic ==="
echo ""

echo "1. System Information:"
docker version
docker-compose --version
echo ""

echo "2. Container Details:"
docker inspect student-lab-ubuntu | grep -E "(State|Health|Mounts|NetworkSettings)"
echo ""

echo "3. Environment Variables:"
docker-compose -f docker-compose.ubuntu.yml config | grep -E "(PLAYIT_SECRET_KEY|ADMIN_PASSWORD|USER_PASSWORD|ROOT_PASSWORD)"
echo ""

echo "4. User Accounts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'"
echo ""

echo "5. Disk Usage:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h
echo ""

echo "6. Memory Usage:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu free -h
echo ""

echo "7. Network Interfaces:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig
echo ""

echo "8. SSH Configuration:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config | grep -E "(PasswordAuthentication|PermitRootLogin|PubkeyAuthentication)"
echo ""
```

## 🚨 Emergency Scripts

### Emergency Status Check
```bash
#!/bin/bash
# emergency-status.sh

echo "=== Emergency Status Check ==="
echo ""

echo "1. Container Status:"
docker ps -a
echo ""

echo "2. System Resources:"
df -h
free -h
echo ""

echo "3. Docker Service:"
sudo systemctl status docker --no-pager
echo ""

echo "4. Recent Logs:"
docker-compose -f docker-compose.ubuntu.yml logs --tail=20
echo ""

echo "5. Network Connectivity:"
ping -c 1 google.com
echo ""
```

### Emergency Recovery Script
```bash
#!/bin/bash
# emergency-recovery.sh

echo "=== Emergency Recovery ==="
echo ""

echo "1. Stopping all containers..."
docker-compose -f docker-compose.ubuntu.yml down --remove-orphans

echo "2. Cleaning up Docker..."
docker system prune -f

echo "3. Recreating data directories..."
mkdir -p data/{admin,user1,user2,user3,user4,user5}

echo "4. Starting fresh container..."
docker-compose -f docker-compose.ubuntu.yml up -d --build

echo "5. Waiting for container to be ready..."
sleep 30

echo "6. Checking container status..."
docker-compose -f docker-compose.ubuntu.yml ps

echo "Emergency recovery completed"
```

## 📊 Monitoring Scripts

### Performance Monitor
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

### Security Monitor
```bash
#!/bin/bash
# security-monitor.sh

echo "=== Security Monitor ==="
echo ""

echo "1. Recent SSH Activity:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
tail -20 /var/log/auth.log
"
echo ""

echo "2. Failed Login Attempts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | tail -10
"
echo ""

echo "3. Active Users:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
who
w
"
echo ""

echo "4. Network Connections:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
netstat -tulpn | grep ssh
"
echo ""
```

## 🔧 Utility Scripts

### Script Installation Helper
```bash
#!/bin/bash
# install-scripts.sh

echo "=== Installing Management Scripts ==="
echo ""

# Create scripts directory
mkdir -p scripts

# Copy all scripts to scripts directory
cp status-check.sh scripts/
cp user-management.sh scripts/
cp health-monitor.sh scripts/
cp backup-lab.sh scripts/
cp quick-diagnostic.sh scripts/

# Make scripts executable
chmod +x scripts/*.sh

echo "Scripts installed in scripts/ directory"
echo "Usage: ./scripts/script-name.sh"
```

### Script Documentation Generator
```bash
#!/bin/bash
# generate-script-docs.sh

echo "=== Script Documentation ==="
echo ""

echo "Available Scripts:"
echo ""

for script in *.sh; do
    if [ -f "$script" ]; then
        echo "## $script"
        echo ""
        echo "Description: $(head -1 "$script" | sed 's/# //')"
        echo ""
        echo "Usage: ./$script"
        echo ""
        echo "---"
        echo ""
    fi
done
```

## 🔗 Related Topics

- **[Container Management](container-management.md)** - Basic container operations
- **[Health Monitoring](health-monitoring.md)** - System health monitoring
- **[Backup and Recovery](backup-recovery.md)** - Data backup and restoration
- **[Emergency Procedures](../troubleshooting/emergency.md)** - Emergency recovery procedures
- **[Diagnostic Commands](../troubleshooting/diagnostics.md)** - Troubleshooting tools