---
layout: default
title: SSH Access Guide
parent: Remote Access
nav_order: 1
permalink: /remote-access/ssh-access/
---

# SSH Access Guide

Complete guide for accessing NazDocker Lab via SSH.

## 🔑 Local SSH Access

### Basic Connection
```bash
# Connect to admin user
ssh admin@localhost -p 2222

# Connect to other users
ssh user1@localhost -p 2222
ssh user2@localhost -p 2222
# ... etc

# Connect as root
ssh root@localhost -p 2222
```

### Default Credentials

| Username | Default Password | Sudo Access |
|----------|------------------|-------------|
| `admin` | `admin123` | ✅ Yes |
| `user1` | `user123` | ❌ No |
| `user2` | `user123` | ❌ No |
| `user3` | `user123` | ❌ No |
| `user4` | `user123` | ❌ No |
| `user5` | `user123` | ❌ No |
| `root` | `root123` | ✅ Yes |

## 🌐 Public SSH Access

### Via Playit.gg Tunneling
1. **Configure tunnel** in `.env` file:
   ```bash
   PLAYIT_SECRET_KEY=your_secret_key_here
   ```

2. **Check tunnel status**:
   ```bash
   docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit"
   ```

3. **Connect via public URL**:
   ```bash
   ssh admin@your-tunnel-url.playit.gg -p 12345
   ```

### Tunnel Management
```bash
# Check tunnel logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit\|tunnel\|url"

# Follow logs in real-time
docker-compose -f docker-compose.ubuntu.yml logs -f lab-environment-ubuntu

# Check playit.gg process
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep playit
```

## 🔧 SSH Configuration

### SSH Service Management
```bash
# Check SSH service status
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Restart SSH service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh restart

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config

# Test SSH locally
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ssh localhost
```

### SSH Configuration Options
```bash
# View current SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config

# Key configuration options:
# PasswordAuthentication yes
# PermitRootLogin yes
# PubkeyAuthentication yes
# Port 22
```

## 🔐 SSH Key Authentication

### Generate SSH Keys
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Generate Ed25519 key (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Add SSH Keys to Container

#### Method 1: Mount SSH Keys
```yaml
# In docker-compose.ubuntu.yml
volumes:
  - ~/.ssh/id_rsa.pub:/home/admin/.ssh/authorized_keys:ro
  - ~/.ssh/id_rsa.pub:/home/user1/.ssh/authorized_keys:ro
```

#### Method 2: Container Shell
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Add SSH key for admin
mkdir -p /home/admin/.ssh
echo "your_public_key_here" >> /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh
chmod 700 /home/admin/.ssh
chmod 600 /home/admin/.ssh/authorized_keys
```

#### Method 3: Dockerfile
```dockerfile
# In Dockerfile.ubuntu
RUN mkdir -p /home/admin/.ssh && \
    echo "your_public_key_here" >> /home/admin/.ssh/authorized_keys && \
    chown -R admin:admin /home/admin/.ssh && \
    chmod 700 /home/admin/.ssh && \
    chmod 600 /home/admin/.ssh/authorized_keys
```

### Connect with SSH Key
```bash
# Connect using SSH key
ssh -i ~/.ssh/id_rsa admin@localhost -p 2222

# Connect with specific key
ssh -i ~/.ssh/my_key admin@localhost -p 2222

# Connect with verbose output
ssh -v admin@localhost -p 2222
```

## 🔧 SSH Client Configuration

### SSH Config File
Create `~/.ssh/config` for easier connections:
```bash
# NazDocker Lab configuration
Host nazdocker-lab
    HostName localhost
    Port 2222
    User admin
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host nazdocker-lab-user1
    HostName localhost
    Port 2222
    User user1
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

### Using SSH Config
```bash
# Connect using config
ssh nazdocker-lab

# Connect to specific user
ssh nazdocker-lab-user1
```

## 🛡️ Security Best Practices

### Password Security
```bash
# Change default passwords immediately
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Change passwords interactively
passwd admin
passwd user1
# ... etc
```

### SSH Key Security
```bash
# Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# Use strong key types
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### SSH Configuration Security
```bash
# Disable password authentication (if using keys)
# In /etc/ssh/sshd_config
PasswordAuthentication no

# Disable root login (recommended)
PermitRootLogin no

# Restrict users (optional)
AllowUsers admin user1 user2 user3 user4 user5
```

## 🔍 Troubleshooting SSH

### Connection Issues
```bash
# Check if container is running
docker-compose -f docker-compose.ubuntu.yml ps

# Check SSH service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Check port mapping
docker port student-lab-ubuntu

# Test SSH locally
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ssh localhost
```

### Authentication Issues
```bash
# Check user accounts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

# Reset password
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:admin123' | chpasswd
"

# Check SSH logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log
```

### Key Authentication Issues
```bash
# Check key permissions
ls -la ~/.ssh/

# Check authorized_keys
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /home/admin/.ssh/authorized_keys

# Test key authentication
ssh -v -i ~/.ssh/id_rsa admin@localhost -p 2222
```

## 📊 SSH Monitoring

### Connection Monitoring
```bash
# Check active SSH connections
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu who

# Check SSH process
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep sshd

# Monitor SSH logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log
```

### Security Auditing
```bash
# Check failed login attempts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log
"

# Check successful logins
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Accepted password' /var/log/auth.log
"

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/ssh/sshd_config | grep -E '(PasswordAuthentication|PermitRootLogin|PubkeyAuthentication)'
"
```

## 🔧 Advanced SSH Features

### Port Forwarding
```bash
# Local port forwarding
ssh -L 8080:localhost:80 admin@localhost -p 2222

# Remote port forwarding
ssh -R 8080:localhost:80 admin@localhost -p 2222

# Dynamic port forwarding (SOCKS proxy)
ssh -D 1080 admin@localhost -p 2222
```

### File Transfer
```bash
# Copy file to container
scp -P 2222 file.txt admin@localhost:/home/admin/

# Copy file from container
scp -P 2222 admin@localhost:/home/admin/file.txt ./

# Copy directory
scp -P 2222 -r directory/ admin@localhost:/home/admin/
```

### X11 Forwarding
```bash
# Enable X11 forwarding
ssh -X admin@localhost -p 2222

# Trusted X11 forwarding
ssh -Y admin@localhost -p 2222
```

## 🔗 Related Topics

- **[Playit.gg Tunneling](playit-tunneling.md)** - Public access via tunneling
- **[Advanced Configuration](../administration/advanced-configuration.md#network-configuration)** - Network setup and troubleshooting
- **[User Management](../user-management/user-accounts.md)** - User account management
- **[SSH Key Setup](../user-management/ssh-keys.md)** - SSH key authentication setup
- **[Security Overview](../security/security-overview.md)** - Security best practices
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common SSH issues