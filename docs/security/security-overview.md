---
layout: default
title: Security Overview
parent: Security
nav_order: 1
permalink: /security/security-overview/
---

# Security Overview

Complete security guide for NazDocker Lab environment.

## 🛡️ Security Architecture

### Defense in Depth
NazDocker Lab implements multiple layers of security:

1. **Container Isolation** - Docker provides process and network isolation
2. **User Access Control** - Multi-user environment with role-based access
3. **SSH Security** - Secure shell with key-based authentication
4. **Network Security** - Firewall and network isolation
5. **Monitoring** - Log monitoring and audit trails

## 🔐 Authentication Security

### Password Security
```bash
# Change default passwords immediately
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Change passwords interactively
passwd admin
passwd user1
# ... etc
```

### SSH Key Authentication
```bash
# Generate SSH keys
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add keys to container
ssh-copy-id -i ~/.ssh/id_ed25519.pub admin@localhost -p 2222

# Disable password authentication (if using keys)
# Edit /etc/ssh/sshd_config
PasswordAuthentication no
```

### User Access Control
```bash
# Check user accounts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

# Check sudo access
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
getent group sudo
"
```

## 🔒 Network Security

### Firewall Configuration
```bash
# Install and configure firewall
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Install UFW
apt-get update
apt-get install -y ufw

# Configure firewall rules
ufw allow ssh
ufw allow 22
ufw --force enable

# Check firewall status
ufw status
```

### Network Isolation
```bash
# Check network interfaces
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig

# Check network connections
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu netstat -tulpn

# Check Docker network
docker network ls
docker network inspect bridge
```

### SSH Configuration Security
```bash
# Secure SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat > /etc/ssh/sshd_config << 'EOF'
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
UsePrivilegeSeparation yes
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin no
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile %h/.ssh/authorized_keys
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
EOF

# Restart SSH service
service ssh restart
"
```

## 🔍 Security Monitoring

### Access Log Monitoring
```bash
# Monitor SSH access logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log

# Check failed login attempts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log
"

# Check successful logins
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Accepted password' /var/log/auth.log
"
```

### Security Audit Script
```bash
#!/bin/bash
# security-audit.sh

echo "=== Security Audit ==="
echo ""

echo "1. User Accounts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"
echo ""

echo "2. SSH Configuration:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/ssh/sshd_config | grep -E '(PasswordAuthentication|PermitRootLogin|PubkeyAuthentication)'
"
echo ""

echo "3. Failed Login Attempts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | tail -10
"
echo ""

echo "4. Active SSH Connections:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
who
"
echo ""

echo "5. File Permissions:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
ls -la /home/
"
echo ""
```

## 🚨 Security Incident Response

### Suspicious Activity Detection
```bash
# Check for unusual login patterns
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | awk '{print \$1,\$2,\$3}' | sort | uniq -c | sort -nr
"

# Check for root login attempts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'root' /var/log/auth.log
"

# Check for SSH key changes
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
find /home -name "authorized_keys" -exec ls -la {} \;
"
```

### Emergency Security Response
```bash
#!/bin/bash
# emergency-security-response.sh

echo "=== Emergency Security Response ==="
echo ""

echo "1. Stopping container..."
docker-compose -f docker-compose.ubuntu.yml down

echo "2. Backup current state for analysis..."
docker cp student-lab-ubuntu:/home ./security-incident-backup-$(date +%Y%m%d-%H%M%S)

echo "3. Resetting all passwords..."
docker-compose -f docker-compose.ubuntu.yml up -d

docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:emergency_admin_pass' | chpasswd
echo 'user1:emergency_user_pass' | chpasswd
echo 'user2:emergency_user_pass' | chpasswd
echo 'user3:emergency_user_pass' | chpasswd
echo 'user4:emergency_user_pass' | chpasswd
echo 'user5:emergency_user_pass' | chpasswd
echo 'root:emergency_root_pass' | chpasswd
"

echo "4. Reviewing logs for suspicious activity..."
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log
grep 'Accepted password' /var/log/auth.log
"

echo "Emergency response completed"
```

## 🔧 Security Hardening

### System Hardening
```bash
# Update system packages
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
apt-get update && apt-get upgrade -y
"

# Install security tools
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
apt-get install -y fail2ban ufw auditd
"

# Configure fail2ban
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
systemctl enable fail2ban
systemctl start fail2ban
"
```

### File System Security
```bash
# Set proper file permissions
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
chmod 700 /home/*/.ssh
chmod 600 /home/*/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh
chown -R user1:user1 /home/user1/.ssh
# ... repeat for all users
"

# Check for world-writable files
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
find /home -perm -002 -type f
"
```

### Network Security Hardening
```bash
# Configure firewall rules
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 22
ufw --force enable
"

# Check firewall status
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
ufw status verbose
"
```

## 📊 Security Monitoring

### Continuous Monitoring
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

### Security Metrics
```bash
#!/bin/bash
# security-metrics.sh

echo "=== Security Metrics ==="
echo ""

echo "Timestamp: $(date)"
echo ""

echo "Failed Login Attempts (Last 24h):"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | grep \"$(date '+%b %d')\" | wc -l
"
echo ""

echo "Successful Logins (Last 24h):"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Accepted password' /var/log/auth.log | grep \"$(date '+%b %d')\" | wc -l
"
echo ""

echo "Active SSH Sessions:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
who | wc -l
"
echo ""
```

## 🔗 Related Topics

- **[Network Security](../administration/advanced-configuration.md#network-security)** - Network security configuration
- **[Security Monitoring](../administration/health-monitoring.md)** - System monitoring and auditing
- **[User Management](../user-management/user-accounts.md)** - User account management
- **[SSH Key Setup](../user-management/ssh-keys.md)** - SSH key authentication
- **[Password Management](../user-management/passwords.md)** - Password security
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Security issues