---
layout: default
title: Emergency Procedures
parent: Troubleshooting
nav_order: 3
permalink: /troubleshooting/emergency/
---

# Emergency Procedures

Emergency recovery procedures for critical situations in NazDocker Lab.

## 🚨 Critical Situations

### Container Won't Start
```bash
# Emergency container restart
docker-compose -f docker-compose.ubuntu.yml down --remove-orphans
docker system prune -f
docker-compose -f docker-compose.ubuntu.yml up -d --build

# If still failing, check logs
docker-compose -f docker-compose.ubuntu.yml logs
```

### SSH Access Lost
```bash
# Emergency container access
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Restart SSH service
service ssh restart

# Check SSH status
service ssh status
```

### Data Corruption
```bash
# Emergency data backup (Ubuntu)
docker cp student-lab-ubuntu:/home ./emergency-data-backup-ubuntu-$(date +%Y%m%d-%H%M%S)

# Emergency data backup (Alpine)
docker cp student-lab-alpine:/home ./emergency-data-backup-alpine-$(date +%Y%m%d-%H%M%S)

# Restore from backup if available
# tar -xzf backup-file.tar.gz
```

## 🔄 Emergency Recovery Steps

### Step 1: Assess the Situation
```bash
# Check container status
docker ps -a

# Check system resources
df -h
free -h

# Check Docker service
sudo systemctl status docker
```

### Step 2: Emergency Backup
```bash
# Quick backup before any changes
docker cp student-lab-ubuntu:/home ./emergency-backup-$(date +%Y%m%d-%H%M%S)

# Backup configuration
cp docker-compose.ubuntu.yml ./emergency-backup-$(date +%Y%m%d-%H%M%S)-config.yml
```

### Step 3: Emergency Access
```bash
# Access container when SSH is down
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Check SSH service
service ssh status

# Restart SSH if needed
service ssh restart
```

### Step 4: Emergency Reset
```bash
# Complete reset (WARNING: Deletes all data)
docker-compose -f docker-compose.ubuntu.yml down -v --remove-orphans --rmi all
docker system prune -a --volumes

# Recreate data directories
mkdir -p data/{alpine,ubuntu}/{admin,user1,user2,user3,user4,user5}
mkdir -p logs/{alpine,ubuntu}

# Restart fresh
docker-compose -f docker-compose.ubuntu.yml up -d --build
```

## 🆘 Emergency Scripts

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
mkdir -p data/{alpine,ubuntu}/{admin,user1,user2,user3,user4,user5}
mkdir -p logs/{alpine,ubuntu}

echo "4. Starting fresh container..."
docker-compose -f docker-compose.ubuntu.yml up -d --build

echo "5. Waiting for container to be ready..."
sleep 30

echo "6. Checking container status..."
docker-compose -f docker-compose.ubuntu.yml ps

echo "Emergency recovery completed"
```

### Emergency Data Recovery
```bash
#!/bin/bash
# emergency-data-recovery.sh

BACKUP_DIR=$1
if [ -z "$BACKUP_DIR" ]; then
    echo "Usage: $0 <backup_directory>"
    exit 1
fi

echo "=== Emergency Data Recovery ==="
echo ""

echo "1. Stopping container..."
docker-compose -f docker-compose.ubuntu.yml down

echo "2. Restoring data from $BACKUP_DIR..."
cp -r "$BACKUP_DIR"/* data/

echo "3. Starting container..."
docker-compose -f docker-compose.ubuntu.yml up -d

echo "4. Verifying restoration..."
ls -la data/

echo "Data recovery completed"
```

## 🔧 Emergency Tools

### Emergency Container Access
```bash
# Access container without SSH
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Access as root
docker-compose -f docker-compose.ubuntu.yml exec -u root lab-environment-ubuntu bash

# Run emergency commands
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh restart
```

### Emergency Network Access
```bash
# Check network connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com

# Check DNS resolution
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu nslookup google.com

# Check network interfaces
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig
```

### Emergency Service Recovery
```bash
# Restart SSH service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh restart

# Restart playit.gg service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu pkill playit-agent

# Check all services
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service --status-all
```

## 🚨 Critical Recovery Procedures

### Complete System Failure
```bash
# 1. Stop everything
docker-compose -f docker-compose.ubuntu.yml down -v --remove-orphans --rmi all

# 2. Clean up Docker
docker system prune -a --volumes

# 3. Restart Docker service
sudo systemctl restart docker

# 4. Recreate environment
mkdir -p data/{alpine,ubuntu}/{admin,user1,user2,user3,user4,user5}
mkdir -p logs/{alpine,ubuntu}
docker-compose -f docker-compose.ubuntu.yml up -d --build
```

### Data Loss Recovery
```bash
# 1. Check for backups
ls -la backups/

# 2. Restore from latest backup
LATEST_BACKUP=$(ls -t backups/ | head -1)
tar -xzf "backups/$LATEST_BACKUP/user-data.tar.gz"

# 3. Restart container
docker-compose -f docker-compose.ubuntu.yml up -d
```

### Security Breach Response
```bash
# 1. Stop container immediately
docker-compose -f docker-compose.ubuntu.yml down

# 2. Backup current state for analysis
docker cp student-lab-ubuntu:/home ./security-incident-backup-$(date +%Y%m%d-%H%M%S)

# 3. Reset all passwords
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:emergency_admin_pass' | chpasswd
echo 'user1:emergency_user_pass' | chpasswd
echo 'user2:emergency_user_pass' | chpasswd
echo 'user3:emergency_user_pass' | chpasswd
echo 'user4:emergency_user_pass' | chpasswd
echo 'user5:emergency_user_pass' | chpasswd
echo 'root:emergency_root_pass' | chpasswd
"

# 4. Review logs for suspicious activity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log
grep 'Accepted password' /var/log/auth.log
"
```

## 📞 Emergency Contacts

### When to Seek Help
- **Container won't start** after emergency procedures
- **Data loss** without backups
- **Security breach** suspected
- **System resources** exhausted
- **Network connectivity** issues persist

### Emergency Information to Collect
```bash
# System information
uname -a
docker version
docker-compose --version

# Container logs
docker-compose -f docker-compose.ubuntu.yml logs > emergency-logs.txt

# System resources
df -h > disk-usage.txt
free -h > memory-usage.txt

# Network information
ifconfig > network-info.txt
```

## 🔗 Related Topics

- **[Common Issues](common-issues.md)** - Solutions to frequent problems
- **[Diagnostic Commands](diagnostics.md)** - Troubleshooting tools
- **[Backup and Recovery](../administration/backup-recovery.md)** - Data backup and restoration
- **[Container Management](../administration/container-management.md)** - Container operations
- **[Security Overview](../security/security-overview.md)** - Security best practices