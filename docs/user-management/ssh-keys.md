# SSH Key Setup

Complete guide for setting up SSH key authentication in NazDocker Lab.

## 🔑 SSH Key Overview

SSH key authentication provides:
- **Enhanced security** over password authentication
- **Convenient access** without typing passwords
- **Automated access** for scripts and tools
- **Audit trail** for access monitoring

## 🚀 Quick Setup

### Generate SSH Key Pair
```bash
# Generate Ed25519 key (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Generate RSA key (alternative)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Generate key without passphrase (for automation)
ssh-keygen -t ed25519 -f ~/.ssh/nazdocker_key -N ""
```

### Add Key to Container
```bash
# Copy public key to container
ssh-copy-id -i ~/.ssh/id_ed25519.pub admin@localhost -p 2222

# Or manually add key
cat ~/.ssh/id_ed25519.pub | ssh admin@localhost -p 2222 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## 🔧 Detailed Setup Methods

### Method 1: SSH-Copy-ID (Recommended)
```bash
# Install ssh-copy-id if not available
# Ubuntu/Debian: sudo apt-get install openssh-client
# macOS: brew install ssh-copy-id

# Copy key to admin user
ssh-copy-id -i ~/.ssh/id_ed25519.pub admin@localhost -p 2222

# Copy key to other users
ssh-copy-id -i ~/.ssh/id_ed25519.pub user1@localhost -p 2222
ssh-copy-id -i ~/.ssh/id_ed25519.pub user2@localhost -p 2222
# ... etc
```

### Method 2: Manual Key Addition
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Add key for admin user
mkdir -p /home/admin/.ssh
echo "your_public_key_here" >> /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh
chmod 700 /home/admin/.ssh
chmod 600 /home/admin/.ssh/authorized_keys

# Add key for other users
mkdir -p /home/user1/.ssh
echo "your_public_key_here" >> /home/user1/.ssh/authorized_keys
chown -R user1:user1 /home/user1/.ssh
chmod 700 /home/user1/.ssh
chmod 600 /home/user1/.ssh/authorized_keys
```

### Method 3: Docker Volume Mount
```yaml
# In docker-compose.ubuntu.yml
volumes:
  - ~/.ssh/id_ed25519.pub:/home/admin/.ssh/authorized_keys:ro
  - ~/.ssh/id_ed25519.pub:/home/user1/.ssh/authorized_keys:ro
  - ~/.ssh/id_ed25519.pub:/home/user2/.ssh/authorized_keys:ro
  - ~/.ssh/id_ed25519.pub:/home/user3/.ssh/authorized_keys:ro
  - ~/.ssh/id_ed25519.pub:/home/user4/.ssh/authorized_keys:ro
  - ~/.ssh/id_ed25519.pub:/home/user5/.ssh/authorized_keys:ro
```

### Method 4: Dockerfile Integration
```dockerfile
# In Dockerfile.ubuntu
RUN mkdir -p /home/admin/.ssh && \
    echo "your_public_key_here" >> /home/admin/.ssh/authorized_keys && \
    chown -R admin:admin /home/admin/.ssh && \
    chmod 700 /home/admin/.ssh && \
    chmod 600 /home/admin/.ssh/authorized_keys

# Repeat for other users
RUN mkdir -p /home/user1/.ssh && \
    echo "your_public_key_here" >> /home/user1/.ssh/authorized_keys && \
    chown -R user1:user1 /home/user1/.ssh && \
    chmod 700 /home/user1/.ssh && \
    chmod 600 /home/user1/.ssh/authorized_keys
```

## 🔐 SSH Key Security

### Key Permissions
```bash
# Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Verify permissions
ls -la ~/.ssh/
```

### Key Types Comparison
| Key Type | Security | Performance | Compatibility |
|----------|----------|-------------|---------------|
| **Ed25519** | High | Fast | Modern systems |
| **RSA 4096** | High | Slower | Universal |
| **RSA 2048** | Medium | Fast | Universal |

### Generate Different Key Types
```bash
# Ed25519 (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# RSA 4096-bit
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# RSA 2048-bit (legacy)
ssh-keygen -t rsa -b 2048 -C "your_email@example.com"
```

## 🔧 SSH Client Configuration

### SSH Config File
Create `~/.ssh/config` for easier connections:
```bash
# NazDocker Lab configuration
Host nazdocker-admin
    HostName localhost
    Port 2222
    User admin
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host nazdocker-user1
    HostName localhost
    Port 2222
    User user1
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host nazdocker-lab
    HostName localhost
    Port 2222
    User admin
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

### Using SSH Config
```bash
# Connect using config
ssh nazdocker-admin

# Connect to specific user
ssh nazdocker-user1

# Connect with default config
ssh nazdocker-lab
```

## 🔍 Testing SSH Keys

### Test Key Authentication
```bash
# Test with specific key
ssh -i ~/.ssh/id_ed25519 admin@localhost -p 2222

# Test with verbose output
ssh -v -i ~/.ssh/id_ed25519 admin@localhost -p 2222

# Test without password prompt
ssh -o PasswordAuthentication=no -i ~/.ssh/id_ed25519 admin@localhost -p 2222
```

### Verify Key Setup
```bash
# Check authorized_keys file
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /home/admin/.ssh/authorized_keys

# Check key permissions
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ls -la /home/admin/.ssh/

# Test key fingerprint
ssh-keygen -lf ~/.ssh/id_ed25519.pub
```

## 🔧 Advanced SSH Key Management

### Multiple Keys for Different Users
```bash
# Generate separate keys for different purposes
ssh-keygen -t ed25519 -f ~/.ssh/nazdocker_admin -C "admin@nazdocker"
ssh-keygen -t ed25519 -f ~/.ssh/nazdocker_user1 -C "user1@nazdocker"

# Add to SSH config
Host nazdocker-admin
    HostName localhost
    Port 2222
    User admin
    IdentityFile ~/.ssh/nazdocker_admin

Host nazdocker-user1
    HostName localhost
    Port 2222
    User user1
    IdentityFile ~/.ssh/nazdocker_user1
```

### Key Rotation
```bash
# Generate new key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_new -C "new_key@nazdocker"

# Add new key to container
ssh-copy-id -i ~/.ssh/id_ed25519_new.pub admin@localhost -p 2222

# Test new key
ssh -i ~/.ssh/id_ed25519_new admin@localhost -p 2222

# Remove old key (optional)
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
sed -i '/old_key_fingerprint/d' /home/admin/.ssh/authorized_keys
"
```

## 🛡️ Security Best Practices

### Key Security
```bash
# Use strong key types
ssh-keygen -t ed25519 -C "your_email@example.com"

# Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Use passphrases for additional security
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### SSH Configuration Security
```bash
# Disable password authentication (if using keys)
# In /etc/ssh/sshd_config
PasswordAuthentication no

# Restrict key authentication
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

# Restrict users (optional)
AllowUsers admin user1 user2 user3 user4 user5
```

### Key Monitoring
```bash
# Monitor SSH key usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Accepted publickey' /var/log/auth.log
"

# Check for unauthorized keys
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /home/admin/.ssh/authorized_keys
"
```

## 🔧 Troubleshooting SSH Keys

### Common Issues
```bash
# Permission denied
chmod 600 ~/.ssh/id_ed25519
chmod 700 ~/.ssh

# Key not accepted
ssh -v -i ~/.ssh/id_ed25519 admin@localhost -p 2222

# Check key format
cat ~/.ssh/id_ed25519.pub

# Verify key in container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /home/admin/.ssh/authorized_keys
```

### Debug SSH Connection
```bash
# Verbose SSH connection
ssh -vvv -i ~/.ssh/id_ed25519 admin@localhost -p 2222

# Test with specific options
ssh -o PreferredAuthentications=publickey -i ~/.ssh/id_ed25519 admin@localhost -p 2222

# Check SSH daemon logs
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log
```

## 🔗 Related Topics

- **[SSH Access](../remote-access/ssh-access.md)** - SSH connection methods
- **[User Accounts](user-accounts.md)** - User account management
- **[Password Management](passwords.md)** - Password configuration
- **[Security Overview](../security/security-overview.md)** - Security best practices
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common SSH issues

## 📋 Best Practices

1. **Use Ed25519 keys** for best security and performance
2. **Set proper permissions** on SSH keys and directories
3. **Use SSH config files** for easier management
4. **Regular key rotation** for security
5. **Monitor key usage** for suspicious activity
6. **Backup SSH keys** securely
7. **Use passphrases** for additional security

## ⚠️ Important Notes

- **Keep private keys secure** and never share them
- **Backup SSH keys** in a secure location
- **Monitor SSH logs** for unauthorized access attempts
- **Regular key rotation** improves security
- **Test key authentication** before disabling passwords

 