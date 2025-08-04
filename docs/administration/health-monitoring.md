---
layout: default
title: Health Monitoring
parent: Administration
nav_order: 3
permalink: /administration/health-monitoring/
---

# Health Monitoring

Complete guide for monitoring system health in NazDocker Lab.

## 🏥 Health Check Overview

The container includes built-in health checks that monitor SSH service availability:

- **Interval**: 30 seconds between checks
- **Timeout**: 10 seconds maximum for each check
- **Start Period**: 40 seconds grace period after container startup
- **Retries**: 3 consecutive failures before marking as unhealthy

## 📊 Health Status Monitoring

### Check Container Health Status
```bash
# Check container health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View detailed health information
docker inspect student-lab-ubuntu | grep -A 20 "Health"

# Monitor health check logs
docker inspect student-lab-ubuntu | grep -A 10 "Healthcheck"

# Test health check manually
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
```

### Health Status Meanings
- **Healthy**: SSH service is running and accepting connections
- **Unhealthy**: SSH service is stopped or not responding
- **Starting**: Container is in the grace period after startup

## 🔍 Health Check Troubleshooting

### Container Shows as Unhealthy
```bash
# Check SSH service status
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Restart SSH service if needed
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh restart

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config

# View health check logs
docker inspect student-lab-ubuntu | grep -A 20 "Health"
```

### Health Check Configuration
```bash
# View health check configuration
docker inspect student-lab-ubuntu | grep -A 10 "Healthcheck"

# Test health check command
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Check health check interval
docker inspect student-lab-ubuntu | grep -A 5 "Healthcheck"
```

## 📈 System Resource Monitoring

### Container Resource Usage
```bash
# Monitor CPU and memory usage
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

# Check disk usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h

# Check memory usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu free -h
```

### Process Monitoring
```bash
# Check running processes
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux

# Check SSH process specifically
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep sshd

# Check system load
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu uptime
```

## 🔧 Health Monitoring Scripts

### Health Status Check Script
```bash
#!/bin/bash
# health-status.sh

echo "=== NazDocker Lab Health Status ==="
echo ""

echo "1. Container Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "2. SSH Service Status:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
echo ""

echo "3. Resource Usage:"
docker stats --no-stream student-lab-ubuntu
echo ""

echo "4. Recent Logs:"
docker-compose -f docker-compose.ubuntu.yml logs --tail=10 lab-environment-ubuntu
echo ""

echo "5. System Resources:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu free -h
echo ""
```

### Comprehensive Health Monitor
```bash
#!/bin/bash
# comprehensive-health-monitor.sh

echo "=== Comprehensive Health Monitor ==="
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
```

## 📊 Performance Monitoring

### CPU and Memory Monitoring
```bash
# Real-time resource monitoring
docker stats student-lab-ubuntu

# Historical resource usage
docker stats --no-stream student-lab-ubuntu

# Container performance details
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu top -bn1
```

### Network Monitoring
```bash
# Check network interfaces
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig

# Check network connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com

# Check network connections
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu netstat -tulpn
```

### Disk I/O Monitoring
```bash
# Check disk usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h

# Check disk I/O
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu iostat

# Check file system health
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu fsck -N
```

## 🔍 Log Monitoring

### SSH Logs
```bash
# View SSH access logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log

# Check failed login attempts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu grep "Failed password" /var/log/auth.log

# Check successful logins
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu grep "Accepted password" /var/log/auth.log
```

### System Logs
```bash
# View system logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu journalctl -f

# Check service status
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu systemctl status --all
```

### Container Logs
```bash
# View container logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu

# Follow logs in real-time
docker-compose -f docker-compose.ubuntu.yml logs -f lab-environment-ubuntu

# View recent logs
docker-compose -f docker-compose.ubuntu.yml logs --tail=50 lab-environment-ubuntu
```

## 🚨 Alert Monitoring

### Health Check Alerts
```bash
#!/bin/bash
# health-alert.sh

HEALTH_STATUS=$(docker inspect student-lab-ubuntu --format='{{.State.Health.Status}}')

if [ "$HEALTH_STATUS" != "healthy" ]; then
    echo "ALERT: Container health status is $HEALTH_STATUS"
    echo "Time: $(date)"
    echo "Container: student-lab-ubuntu"
    echo "Status: $HEALTH_STATUS"
    
    # Send alert (customize as needed)
    # mail -s "NazDocker Lab Health Alert" admin@example.com <<< "Container is unhealthy"
fi
```

### Resource Alert Monitoring
```bash
#!/bin/bash
# resource-alert.sh

# Check memory usage
MEMORY_USAGE=$(docker stats --no-stream --format "{{.MemPerc}}" student-lab-ubuntu | sed 's/%//')

if (( $(echo "$MEMORY_USAGE > 80" | bc -l) )); then
    echo "ALERT: High memory usage: ${MEMORY_USAGE}%"
fi

# Check disk usage
DISK_USAGE=$(docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "ALERT: High disk usage: ${DISK_USAGE}%"
fi
```

## 📈 Health Metrics Collection

### Health Metrics Script
```bash
#!/bin/bash
# health-metrics.sh

echo "=== Health Metrics Collection ==="
echo ""

echo "Timestamp: $(date)"
echo ""

echo "Container Health:"
docker inspect student-lab-ubuntu --format='{{.State.Health.Status}}'
echo ""

echo "Resource Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
echo ""

echo "SSH Service Status:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
echo ""

echo "System Resources:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h | grep -E "(Filesystem|/)"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu free -h
echo ""

echo "Network Connectivity:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping -c 1 google.com > /dev/null && echo "Internet: OK" || echo "Internet: FAILED"
echo ""
```

## 🔧 Health Check Customization

### Custom Health Check
```dockerfile
# Custom health check in Dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD service ssh status && pgrep sshd || exit 1
```

### Health Check with Custom Script
```bash
#!/bin/bash
# custom-health-check.sh

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

exit 0
```

## 🔗 Related Topics

- **[Container Management](container-management.md)** - Managing Docker containers
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common health issues
- **[Emergency Procedures](../troubleshooting/emergency.md)** - Emergency recovery
- **[Backup and Recovery](backup-recovery.md)** - Data backup and restoration
- **[Advanced Configuration](advanced-configuration.md)** - System optimization