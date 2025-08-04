---
layout: default
title: Backup and Recovery
parent: Administration
nav_order: 4
permalink: /administration/backup-recovery/
---

# Backup and Recovery

Complete guide for backing up and recovering NazDocker Lab data and configuration.

## 💾 Backup Strategies

### User Data Backup
```bash
# Backup all user data
tar -czf lab-backup-$(date +%Y%m%d-%H%M%S).tar.gz data/

# Backup specific user
tar -czf user1-backup-$(date +%Y%m%d-%H%M%S).tar.gz data/user1/

# Backup with compression and exclusions
tar -czf lab-backup-$(date +%Y%m%d).tar.gz data/ --exclude='*.tmp' --exclude='*.log'
```

### Configuration Backup
```bash
# Backup Docker configuration
docker-compose -f docker-compose.ubuntu.yml config > docker-compose-backup-$(date +%Y%m%d).yml

# Backup Dockerfile
cp Dockerfile.ubuntu Dockerfile.ubuntu.backup-$(date +%Y%m%d)

# Backup environment variables (without sensitive data)
cp .env.example .env.example.backup-$(date +%Y%m%d)
```

### Complete System Backup
```bash
#!/bin/bash
# complete-backup.sh

BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in $BACKUP_DIR..."

# Backup user data
tar -czf "$BACKUP_DIR/user-data.tar.gz" data/

# Backup configuration
cp docker-compose.ubuntu.yml "$BACKUP_DIR/"
cp Dockerfile.ubuntu "$BACKUP_DIR/"
cp .env.example "$BACKUP_DIR/"

# Backup container state
docker-compose ps > "$BACKUP_DIR/container-status.txt"

echo "Backup completed: $BACKUP_DIR"
```

## 🔄 Restore Procedures

### Restore User Data
```bash
# Restore all data
tar -xzf lab-backup-20231201-143022.tar.gz

# Restore specific user
tar -xzf user1-backup-20231201-143022.tar.gz

# Verify restoration
ls -la data/
```

### Restore Configuration
```bash
# Restore Docker Compose configuration
cp docker-compose-backup-20231201.yml docker-compose.ubuntu.yml

# Restore Dockerfile
cp Dockerfile.ubuntu.backup-20231201 Dockerfile.ubuntu

# Rebuild container
docker-compose -f docker-compose.ubuntu.yml up -d --build
```

### Complete System Restore
```bash
#!/bin/bash
# complete-restore.sh

BACKUP_DIR=$1
if [ -z "$BACKUP_DIR" ]; then
    echo "Usage: $0 <backup_directory>"
    exit 1
fi

echo "Restoring from $BACKUP_DIR..."

# Stop container
docker-compose -f docker-compose.ubuntu.yml down

# Restore user data
tar -xzf "$BACKUP_DIR/user-data.tar.gz"

# Restore configuration
cp "$BACKUP_DIR/docker-compose.ubuntu.yml" ./
cp "$BACKUP_DIR/Dockerfile.ubuntu" ./

# Start container
docker-compose -f docker-compose.ubuntu.yml up -d --build

echo "Restore completed"
```

## 🤖 Automated Backup Scripts

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

### Alpine Backup Script
```bash
#!/bin/bash
# backup-alpine.sh

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

## 📊 Backup Verification

### Verify Backup Integrity
```bash
# Check backup file size
ls -lh lab-backup-*.tar.gz

# Verify backup contents
tar -tzf lab-backup-20231201.tar.gz | head -20

# Test backup extraction
tar -tzf lab-backup-20231201.tar.gz > /dev/null && echo "Backup is valid" || echo "Backup is corrupted"
```

### Verify Restored Data
```bash
# Check user data integrity
ls -la data/
du -sh data/*

# Verify user accounts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

# Check file permissions
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
ls -la /home/
"
```

## 🔄 Incremental Backup

### Incremental Backup Script
```bash
#!/bin/bash
# incremental-backup.sh

LAST_BACKUP="backups/last-backup.txt"
CURRENT_TIME=$(date +%s)

# Create backup directory
BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Check if this is the first backup
if [ ! -f "$LAST_BACKUP" ]; then
    echo "Creating full backup..."
    tar -czf "$BACKUP_DIR/full-backup.tar.gz" data/
    echo "$CURRENT_TIME" > "$LAST_BACKUP"
else
    echo "Creating incremental backup..."
    LAST_TIME=$(cat "$LAST_BACKUP")
    
    # Find files modified since last backup
    find data/ -newermt "@$LAST_TIME" -type f > "$BACKUP_DIR/changed-files.txt"
    
    # Create incremental backup
    tar -czf "$BACKUP_DIR/incremental-backup.tar.gz" -T "$BACKUP_DIR/changed-files.txt"
    
    echo "$CURRENT_TIME" > "$LAST_BACKUP"
fi

echo "Incremental backup completed: $BACKUP_DIR"
```

## 🗂️ Backup Organization

### Backup Directory Structure
```
backups/
├── 20231201-143022/
│   ├── user-data.tar.gz
│   ├── docker-compose.ubuntu.yml
│   ├── Dockerfile.ubuntu
│   └── container-status.txt
├── 20231202-091500/
│   ├── user-data.tar.gz
│   ├── docker-compose.ubuntu.yml
│   ├── Dockerfile.ubuntu
│   └── container-status.txt
└── last-backup.txt
```

### Backup Retention Policy
```bash
#!/bin/bash
# cleanup-old-backups.sh

# Keep backups for 30 days
find backups/ -type d -name "2023*" -mtime +30 -exec rm -rf {} \;

# Keep only last 10 backups
ls -t backups/ | tail -n +11 | xargs -I {} rm -rf backups/{}

echo "Old backups cleaned up"
```

## 🚨 Emergency Recovery

### Emergency Backup
```bash
#!/bin/bash
# emergency-backup.sh

echo "Creating emergency backup..."

# Quick backup before emergency procedures
docker cp student-lab-ubuntu:/home ./emergency-backup-$(date +%Y%m%d-%H%M%S)

# Backup configuration
cp docker-compose.ubuntu.yml ./emergency-backup-$(date +%Y%m%d-%H%M%S)-config.yml

echo "Emergency backup completed"
```

### Emergency Restore
```bash
#!/bin/bash
# emergency-restore.sh

BACKUP_DIR=$1
if [ -z "$BACKUP_DIR" ]; then
    echo "Usage: $0 <emergency_backup_directory>"
    exit 1
fi

echo "Emergency restore from $BACKUP_DIR..."

# Stop container
docker-compose -f docker-compose.ubuntu.yml down

# Restore data
cp -r "$BACKUP_DIR"/* data/

# Start container
docker-compose -f docker-compose.ubuntu.yml up -d

echo "Emergency restore completed"
```

## 🔍 Backup Monitoring

### Backup Status Check
```bash
#!/bin/bash
# backup-status.sh

echo "=== Backup Status ==="
echo ""

echo "Recent backups:"
ls -la backups/ | tail -10
echo ""

echo "Backup sizes:"
du -sh backups/*
echo ""

echo "Last backup time:"
if [ -f "backups/last-backup.txt" ]; then
    date -d "@$(cat backups/last-backup.txt)"
else
    echo "No backup timestamp found"
fi
echo ""

echo "Available disk space:"
df -h .
echo ""
```

## 🔗 Related Topics

- **[Container Management](container-management.md)** - Managing Docker containers
- **[Environment Variables](environment-variables.md)** - Configuration management
- **[User Management](../user-management/user-accounts.md)** - User account management
- **[Emergency Procedures](../troubleshooting/emergency.md)** - Emergency recovery procedures
- **[Maintenance](../maintenance/regular-maintenance.md)** - Regular maintenance tasks