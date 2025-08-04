# Diagnostic Commands

Complete guide for troubleshooting and diagnostics in NazDocker Lab.

## 🔍 System Diagnostics

### Container Status
```bash
# Check container status
docker ps -a

# Check container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View container details
docker inspect student-lab-ubuntu

# Check container logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu
```

### Resource Usage
```bash
# Check resource usage
docker stats student-lab-ubuntu

# Check disk usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h

# Check memory usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu free -h

# Check CPU usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu top -bn1
```

## 🔧 Network Diagnostics

### Network Connectivity
```bash
# Test internet connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com

# Check DNS resolution
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu nslookup google.com

# Check network interfaces
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig

# Check network connections
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu netstat -tulpn
```

### Port and Service Checks
```bash
# Check SSH port
docker port student-lab-ubuntu

# Test SSH locally
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ssh localhost

# Check SSH service status
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Check listening ports
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ss -tulpn
```

## 🛠️ Service Diagnostics

### SSH Service
```bash
# Check SSH process
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep sshd

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config

# Test SSH connection
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ssh -o ConnectTimeout=5 localhost

# Check SSH logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log
```

### Playit.gg Tunnel
```bash
# Check tunnel process
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep playit

# Check tunnel logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit\|tunnel"

# Check tunnel environment
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu env | grep PLAYIT
```

## 👥 User Diagnostics

### User Account Checks
```bash
# List all users
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

# Check user home directories
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ls -la /home/

# Check user permissions
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
for user in admin user1 user2 user3 user4 user5; do
    echo "User: $user"
    ls -la /home/$user/
    echo ""
done
"
```

### Authentication Tests
```bash
# Test password authentication
sshpass -p 'admin123' ssh -o ConnectTimeout=5 admin@localhost -p 2222

# Test SSH key authentication
ssh -i ~/.ssh/id_ed25519 -o ConnectTimeout=5 admin@localhost -p 2222

# Check SSH key permissions
ls -la ~/.ssh/
```

## 📊 Performance Diagnostics

### System Performance
```bash
# Check system load
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu uptime

# Check process list
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux

# Check memory usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /proc/meminfo

# Check disk I/O
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu iostat
```

### Container Performance
```bash
# Monitor container stats
docker stats --no-stream student-lab-ubuntu

# Check container resource limits
docker inspect student-lab-ubuntu | grep -A 10 "HostConfig"

# Check container mounts
docker inspect student-lab-ubuntu | grep -A 10 "Mounts"
```

## 🔍 Log Analysis

### SSH Logs
```bash
# View recent SSH logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -50 /var/log/auth.log

# Check failed login attempts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | tail -20
"

# Check successful logins
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Accepted password' /var/log/auth.log | tail -20
"
```

### System Logs
```bash
# View system logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu journalctl -f

# Check service status
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu systemctl status --all

# Check boot logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu dmesg | tail -20
```

## 🔧 Diagnostic Scripts

### Comprehensive Diagnostic
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

### Quick Health Check
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

### Network Diagnostic
```bash
#!/bin/bash
# network-diagnostic.sh

echo "=== Network Diagnostic ==="
echo ""

echo "1. Network Interfaces:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig
echo ""

echo "2. Network Connections:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu netstat -tulpn
echo ""

echo "3. DNS Resolution:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu nslookup google.com
echo ""

echo "4. Internet Connectivity:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping -c 3 google.com
echo ""

echo "5. Port Mapping:"
docker port student-lab-ubuntu
echo ""
```

## 🚨 Emergency Diagnostics

### Emergency Access
```bash
# Access container when SSH is down
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Check SSH service
service ssh status

# Restart SSH if needed
service ssh restart
```

### Data Recovery
```bash
# Check data directory
ls -la data/

# Check container data
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ls -la /home/

# Backup data if needed
docker cp student-lab-ubuntu:/home ./emergency-backup-$(date +%Y%m%d-%H%M%S)
```

## 📊 Performance Monitoring

### Real-time Monitoring
```bash
# Monitor container stats
docker stats student-lab-ubuntu

# Monitor system resources
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu top

# Monitor network traffic
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu iftop
```

### Log Monitoring
```bash
# Follow SSH logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log

# Follow container logs
docker-compose -f docker-compose.ubuntu.yml logs -f lab-environment-ubuntu

# Follow system logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu journalctl -f
```

## 🔗 Related Topics

- **[Common Issues](common-issues.md)** - Solutions to frequent problems
- **[Emergency Procedures](emergency.md)** - Emergency recovery procedures
- **[Health Monitoring](../administration/health-monitoring.md)** - System health monitoring
- **[Container Management](../administration/container-management.md)** - Container operations
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common issues

## 📋 Best Practices

1. **Run diagnostics regularly** to catch issues early
2. **Document diagnostic procedures** for consistency
3. **Use automated scripts** for routine checks
4. **Monitor trends** in diagnostic output
5. **Keep diagnostic tools updated**
6. **Test diagnostic procedures** regularly
7. **Document findings** for future reference

## ⚠️ Important Notes

- **Run diagnostics before making changes** to understand the current state
- **Keep diagnostic output** for troubleshooting
- **Use multiple diagnostic tools** for comprehensive analysis
- **Document diagnostic procedures** for team use
- **Regular diagnostic checks** help prevent issues

 