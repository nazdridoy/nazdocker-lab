---
layout: default
title: Regular Maintenance
parent: Maintenance
nav_order: 1
permalink: /maintenance/regular-maintenance/
---

# Regular Maintenance

Complete guide for maintaining and managing NazDocker Lab environment.

## 🔧 Regular Maintenance Tasks

### Weekly Tasks

#### System Updates
```bash
# Update package lists
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get update

# Check for security updates
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get upgrade --dry-run

# Clean up old packages
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get autoremove -y
```

#### Health Checks
```bash
# Check container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# Check SSH service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Check disk usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h

# Check memory usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu free -h
```

#### Log Review
```bash
# Check SSH logs for issues
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | tail -10
"

# Check system logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu journalctl --since "1 week ago" | grep -i error

# Check container logs
docker-compose -f docker-compose.ubuntu.yml logs --since "1 week ago" lab-environment-ubuntu
```

### Monthly Tasks

#### Full System Update
```bash
# Full system update
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get update && apt-get upgrade -y

# Rebuild container with updated base image
docker-compose -f docker-compose.ubuntu.yml up -d --build

# Review and rotate logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu find /var/log -name "*.log" -mtime +30 -delete
```

#### Security Audit
```bash
# Check for security vulnerabilities
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get audit

# Review user accounts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/passwd | grep -E ":(/bin/bash|/bin/sh)$"

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config | grep -E "(PasswordAuthentication|PermitRootLogin|PubkeyAuthentication)"
```

#### Backup Verification
```bash
# Test backup restoration for Ubuntu
tar -czf ubuntu-test-backup-$(date +%Y%m%d).tar.gz data/ubuntu/

# Test backup restoration for Alpine
tar -czf alpine-test-backup-$(date +%Y%m%d).tar.gz data/alpine/

# Test backup restoration for both
tar -czf full-test-backup-$(date +%Y%m%d).tar.gz data/

# Verify backup integrity
tar -tzf ubuntu-test-backup-$(date +%Y%m%d).tar.gz > /dev/null && echo "Ubuntu backup is valid" || echo "Ubuntu backup is corrupted"
tar -tzf alpine-test-backup-$(date +%Y%m%d).tar.gz > /dev/null && echo "Alpine backup is valid" || echo "Alpine backup is corrupted"

# Clean up test backups
rm ubuntu-test-backup-$(date +%Y%m%d).tar.gz alpine-test-backup-$(date +%Y%m%d).tar.gz full-test-backup-$(date +%Y%m%d).tar.gz
```

### Quarterly Tasks

#### Security Updates
```bash
# Security audit
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get audit

# Review user accounts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/passwd | grep -E ":(/bin/bash|/bin/sh)$"

# Update SSH keys
# Review and update authorized_keys files
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
for user in admin user1 user2 user3 user4 user5; do
    echo "Checking SSH keys for $user:"
    ls -la /home/$user/.ssh/ 2>/dev/null || echo "No SSH directory for $user"
done
"
```

#### Performance Review
```bash
# Check resource usage trends
docker stats --no-stream student-lab-ubuntu

# Review disk usage patterns
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
du -sh /home/* | sort -hr
"

# Check for performance issues
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'Top processes by CPU:'
ps aux --sort=-%cpu | head -5
echo 'Top processes by memory:'
ps aux --sort=-%mem | head -5
"
```

## 🚨 Emergency Procedures

### Container Reset
```bash
# Stop and remove container
docker-compose -f docker-compose.ubuntu.yml down

# Remove volumes (WARNING: Deletes all data)
docker-compose -f docker-compose.ubuntu.yml down -v

# Rebuild and start
docker-compose -f docker-compose.ubuntu.yml up -d --build
```

### Emergency Access
```bash
# Access container when SSH is down
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Check SSH service
service ssh status

# Restart SSH if needed
service ssh restart
```

### Emergency Backup
```bash
# Quick backup before emergency procedures (Ubuntu)
docker cp student-lab-ubuntu:/home ./emergency-backup-ubuntu-$(date +%Y%m%d-%H%M%S)

# Quick backup before emergency procedures (Alpine)
docker cp student-lab-alpine:/home ./emergency-backup-alpine-$(date +%Y%m%d-%H%M%S)

# Backup configuration
cp docker-compose.ubuntu.yml ./emergency-backup-$(date +%Y%m%d-%H%M%S)-ubuntu-config.yml
cp docker-compose.alpine.yml ./emergency-backup-$(date +%Y%m%d-%H%M%S)-alpine-config.yml

# Backup environment variables
cp .env ./emergency-backup-$(date +%Y%m%d-%H%M%S)-env
```

### Emergency Recovery
```bash
#!/bin/bash
# emergency-recovery.sh

echo "=== Emergency Recovery ==="
echo ""

echo "1. Stopping container..."
docker-compose -f docker-compose.ubuntu.yml down

echo "2. Creating emergency backup..."
docker cp student-lab-ubuntu:/home ./emergency-backup-$(date +%Y%m%d-%H%M%S) 2>/dev/null || echo "Container not running"

echo "3. Cleaning up Docker..."
docker system prune -f

echo "4. Rebuilding container..."
docker-compose -f docker-compose.ubuntu.yml up -d --build

echo "5. Waiting for container to be ready..."
sleep 30

echo "6. Checking container status..."
docker-compose -f docker-compose.ubuntu.yml ps

echo "Emergency recovery completed"
```

## 🧹 Cleanup Procedures

### Complete Cleanup
```bash
# Stop and remove everything
docker-compose -f docker-compose.ubuntu.yml down -v --remove-orphans --rmi all

# Remove all unused Docker resources
docker system prune -a --volumes

# Verify cleanup
docker ps -a
docker network ls
docker volume ls
docker images
```

### Selective Cleanup
```bash
# Remove specific resources
docker rm -f student-lab-ubuntu
docker network rm nazdocker-lab_lab-network
docker volume rm nazdocker-lab_user-data

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune
```

### Log Cleanup
```bash
# Clean up old logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
find /var/log -name '*.log' -mtime +30 -delete
find /var/log -name '*.gz' -mtime +30 -delete
"

# Clean up Docker logs
docker system prune -f

# Clean up backup logs
find backups/ -name "*.log" -mtime +90 -delete
```

## 📊 Maintenance Scripts

### Weekly Maintenance Script
```bash
#!/bin/bash
# weekly-maintenance.sh

echo "=== Weekly Maintenance ==="
echo ""

echo "1. Updating package lists..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get update

echo "2. Checking for security updates..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get upgrade --dry-run

echo "3. Cleaning up old packages..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get autoremove -y

echo "4. Checking container health..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

echo "5. Checking disk usage..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h

echo "6. Reviewing recent logs..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'Recent failed login attempts:'
grep 'Failed password' /var/log/auth.log | tail -5
"

echo "Weekly maintenance completed"
```

### Monthly Maintenance Script
```bash
#!/bin/bash
# monthly-maintenance.sh

echo "=== Monthly Maintenance ==="
echo ""

echo "1. Full system update..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get update && apt-get upgrade -y

echo "2. Rebuilding container..."
docker-compose -f docker-compose.ubuntu.yml up -d --build

echo "3. Security audit..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get audit

echo "4. Reviewing user accounts..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

echo "5. Rotating old logs..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu find /var/log -name "*.log" -mtime +30 -delete

echo "6. Creating backup..."
tar -czf monthly-backup-$(date +%Y%m%d).tar.gz data/

echo "Monthly maintenance completed"
```

### Quarterly Maintenance Script
```bash
#!/bin/bash
# quarterly-maintenance.sh

echo "=== Quarterly Maintenance ==="
echo ""

echo "1. Security audit..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu apt-get audit

echo "2. Reviewing SSH keys..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
for user in admin user1 user2 user3 user4 user5; do
    echo "SSH keys for $user:"
    ls -la /home/$user/.ssh/ 2>/dev/null || echo "No SSH directory for $user"
done
"

echo "3. Performance review..."
docker stats --no-stream student-lab-ubuntu

echo "4. Disk usage analysis..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
du -sh /home/* | sort -hr
"

echo "5. System resource check..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'Memory usage:'
free -h
echo 'Disk usage:'
df -h
"

echo "Quarterly maintenance completed"
```

## 📈 Maintenance Monitoring

### Maintenance Status Check
```bash
#!/bin/bash
# maintenance-status.sh

echo "=== Maintenance Status ==="
echo ""

echo "1. Last package update:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
stat /var/lib/apt/lists/ | grep Modify
"

echo "2. Container uptime:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu uptime

echo "3. Recent maintenance activities:"
ls -la backups/ | tail -5

echo "4. System health:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

echo "5. Resource usage:"
docker stats --no-stream student-lab-ubuntu
```

### Maintenance Schedule
```bash
#!/bin/bash
# maintenance-schedule.sh

echo "=== Maintenance Schedule ==="
echo ""

echo "Weekly Tasks:"
echo "- Update package lists"
echo "- Check for security updates"
echo "- Clean up old packages"
echo "- Review logs"
echo "- Health checks"
echo ""

echo "Monthly Tasks:"
echo "- Full system update"
echo "- Rebuild container"
echo "- Security audit"
echo "- Log rotation"
echo "- Backup verification"
echo ""

echo "Quarterly Tasks:"
echo "- Comprehensive security audit"
echo "- SSH key review"
echo "- Performance analysis"
echo "- Resource optimization"
echo "- Documentation review"
```

## 🔗 Related Topics

- **[Advanced Configuration](../administration/advanced-configuration.md)** - Advanced configuration options
- **[Health Monitoring](../administration/health-monitoring.md)** - System health monitoring
- **[Backup and Recovery](../administration/backup-recovery.md)** - Data backup and restoration
- **[Emergency Procedures](../troubleshooting/emergency.md)** - Emergency recovery procedures
- **[Advanced Configuration](../administration/advanced-configuration.md)** - System optimization guidelines