# User Account Management

Complete guide for managing user accounts in NazDocker Lab.

## 👥 User Account Overview

| Username | Default Password | Sudo Access | Purpose |
|----------|------------------|-------------|---------|
| `admin` | `admin123` | ✅ Yes | Administrative tasks |
| `user1` | `user123` | ❌ No | Regular development |
| `user2` | `user123` | ❌ No | Regular development |
| `user3` | `user123` | ❌ No | Regular development |
| `user4` | `user123` | ❌ No | Regular development |
| `user5` | `user123` | ❌ No | Regular development |
| `root` | `root123` | ✅ Yes | System administration |

## ➕ Adding New Users

### Method 1: Container Shell (Recommended)
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Add new user
useradd -m -s /bin/bash newuser
echo "newuser:password123" | chpasswd

# Add to sudo group (optional)
usermod -aG sudo newuser

# Create home directory structure
mkdir -p /home/newuser/{Documents,Downloads,Projects}
chown -R newuser:newuser /home/newuser
```

### Method 2: Environment Variables
```bash
# Add to .env file
USER_PASSWORD=newpassword123

# Restart container
docker-compose -f docker-compose.ubuntu.yml down && docker-compose -f docker-compose.ubuntu.yml up -d
```

### Method 3: Dockerfile Modification
```dockerfile
# Add to Dockerfile.ubuntu
RUN useradd -m -s /bin/bash newuser && \
    echo "newuser:password123" | chpasswd && \
    usermod -aG sudo newuser
```

## ➖ Removing Users

```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Remove user and home directory
userdel -r username

# Remove from sudo group (if applicable)
gpasswd -d username sudo
```

## 📋 Listing Users

```bash
# List all users with shell access
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

# List users with sudo access
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
getent group sudo
"

# List all users
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cut -d: -f1 /etc/passwd | sort
"
```

## 🔐 Password Management

### Changing User Passwords

#### Method 1: Interactive (Recommended)
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

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
docker-compose -f docker-compose.ubuntu.yml down && docker-compose -f docker-compose.ubuntu.yml up -d
```

#### Method 3: Command Line
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Change passwords non-interactively
echo "admin:newpassword" | chpasswd
echo "user1:newpassword" | chpasswd
# ... etc
```

## 🔑 SSH Key Authentication

### Method 1: Mount SSH Keys
```yaml
# In docker-compose.ubuntu.yml
volumes:
  - ~/.ssh/id_rsa.pub:/home/admin/.ssh/authorized_keys:ro
  - ~/.ssh/id_rsa.pub:/home/user1/.ssh/authorized_keys:ro
```

### Method 2: Container Shell
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

### Method 3: Dockerfile
```dockerfile
# In Dockerfile
RUN mkdir -p /home/admin/.ssh && \
    echo "your_public_key_here" >> /home/admin/.ssh/authorized_keys && \
    chown -R admin:admin /home/admin/.ssh && \
    chmod 700 /home/admin/.ssh && \
    chmod 600 /home/admin/.ssh/authorized_keys
```

## 🛡️ Security Auditing

```bash
# Check for failed login attempts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log
"

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/ssh/sshd_config | grep -E '(PasswordAuthentication|PermitRootLogin|PubkeyAuthentication)'
"

# Check user permissions
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
ls -la /home/
"
```

## 📁 Home Directory Management

### Creating Home Directory Structure
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Create standard directories for all users
for user in admin user1 user2 user3 user4 user5; do
    mkdir -p /home/$user/{Documents,Downloads,Projects,.ssh}
    chown -R $user:$user /home/$user
    chmod 700 /home/$user/.ssh
done
```

### Managing User Data
```bash
# Backup user data
tar -czf user-backup-$(date +%Y%m%d).tar.gz data/

# Restore user data
tar -xzf user-backup-20231201.tar.gz

# Check disk usage per user
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
du -sh /home/* | sort -hr
"
```

## 🔧 User Management Scripts

### Status Check Script
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
```

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
    *)
        echo "Usage: $0 {add|remove|list} [username]"
        ;;
esac
```

## 🔗 Related Topics

- **[Password Management](passwords.md)** - Detailed password configuration
- **[SSH Key Setup](ssh-keys.md)** - SSH key authentication setup
- **[Environment Variables](../administration/environment-variables.md)** - User configuration via environment variables
- **[Security Overview](../security/security-overview.md)** - Security best practices
- **[Container Management](../administration/container-management.md)** - Managing the container environment

## 📝 Best Practices

1. **Change default passwords** immediately after first login
2. **Use SSH keys** instead of passwords when possible
3. **Regular user audits** to remove unused accounts
4. **Monitor access logs** for suspicious activity
5. **Backup user data** regularly
6. **Use strong passwords** for all accounts
7. **Limit sudo access** to necessary users only

 