# Password Management

Complete guide for managing passwords in NazDocker Lab.

## 🔐 Default Passwords

| Username | Default Password | Sudo Access | Purpose |
|----------|------------------|-------------|---------|
| `admin` | `admin123` | ✅ Yes | Administrative tasks |
| `user1` | `user123` | ❌ No | Regular development |
| `user2` | `user123` | ❌ No | Regular development |
| `user3` | `user123` | ❌ No | Regular development |
| `user4` | `user123` | ❌ No | Regular development |
| `user5` | `user123` | ❌ No | Regular development |
| `root` | `root123` | ✅ Yes | System administration |

## ⚠️ Security Warning

**IMPORTANT**: Change all default passwords immediately after first login for security.

## 🔄 Changing Passwords

### Method 1: Interactive (Recommended)
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Change passwords interactively
passwd admin
passwd user1
passwd user2
passwd user3
passwd user4
passwd user5
passwd root
```

### Method 2: Environment Variables
```bash
# Edit .env file
ADMIN_PASSWORD=your_secure_admin_password
USER_PASSWORD=your_secure_user_password
ROOT_PASSWORD=your_secure_root_password

# Restart container
docker-compose -f docker-compose.ubuntu.yml down && docker-compose -f docker-compose.ubuntu.yml up -d
```

### Method 3: Command Line
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Change passwords non-interactively
echo "admin:new_secure_password" | chpasswd
echo "user1:new_secure_password" | chpasswd
echo "user2:new_secure_password" | chpasswd
echo "user3:new_secure_password" | chpasswd
echo "user4:new_secure_password" | chpasswd
echo "user5:new_secure_password" | chpasswd
echo "root:new_secure_root_password" | chpasswd
```

## 🔒 Password Security Best Practices

### Strong Password Requirements
- **Minimum 12 characters**
- **Mix of uppercase and lowercase letters**
- **Include numbers and special characters**
- **Avoid common words and patterns**
- **Use unique passwords for each account**

### Password Examples
```bash
# Good passwords
MySecurePass123!
Complex@Password456
Strong#Pass789$

# Bad passwords
password123
admin123
user123
123456789
```

### Password Policy Enforcement
```bash
# Install password quality checker
apt-get install -y libpam-pwquality

# Configure password policy
# Edit /etc/pam.d/common-password
# password requisite pam_pwquality.so retry=3 minlen=12 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1
```

## 🔧 Password Management Scripts

### Bulk Password Change Script
```bash
#!/bin/bash
# bulk-password-change.sh

echo "=== Bulk Password Change ==="
echo ""

# Read new passwords
read -s -p "Enter new admin password: " ADMIN_PASS
echo ""
read -s -p "Enter new user password: " USER_PASS
echo ""
read -s -p "Enter new root password: " ROOT_PASS
echo ""

# Change passwords
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:$ADMIN_PASS' | chpasswd
echo 'user1:$USER_PASS' | chpasswd
echo 'user2:$USER_PASS' | chpasswd
echo 'user3:$USER_PASS' | chpasswd
echo 'user4:$USER_PASS' | chpasswd
echo 'user5:$USER_PASS' | chpasswd
echo 'root:$ROOT_PASS' | chpasswd
"

echo "All passwords changed successfully"
```

### Password Reset Script
```bash
#!/bin/bash
# password-reset.sh

USERNAME=$1
if [ -z "$USERNAME" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Generate random password
NEW_PASSWORD=$(openssl rand -base64 12)

# Reset password
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo '$USERNAME:$NEW_PASSWORD' | chpasswd
"

echo "Password for $USERNAME reset to: $NEW_PASSWORD"
echo "Please change this password immediately after login"
```

### Password Audit Script
```bash
#!/bin/bash
# password-audit.sh

echo "=== Password Audit ==="
echo ""

echo "Users with shell access:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"
echo ""

echo "Password expiration status:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
chage -l admin
"
echo ""

echo "Failed login attempts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | tail -10
"
```

## 🔍 Password Verification

### Check Password Status
```bash
# Check if user can change password
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
passwd -S admin
"

# Check password expiration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
chage -l admin
"

# Check password quality
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'test_password' | pwscore
"
```

### Test Password Authentication
```bash
# Test SSH password authentication
ssh admin@localhost -p 2222

# Test with specific password
sshpass -p 'password' ssh admin@localhost -p 2222

# Test password change
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:newpassword' | chpasswd && echo 'Password changed successfully'
"
```

## 🔐 Advanced Password Security

### Password History
```bash
# Configure password history
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
# Edit /etc/pam.d/common-password
# password requisite pam_pwhistory.so remember=5
"
```

### Password Expiration
```bash
# Set password expiration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
chage -M 90 admin  # Expire in 90 days
chage -M 90 user1
chage -M 90 user2
chage -M 90 user3
chage -M 90 user4
chage -M 90 user5
chage -M 90 root
"
```

### Account Lockout
```bash
# Configure account lockout
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
# Edit /etc/pam.d/common-auth
# auth required pam_tally2.so deny=5 unlock_time=300
"
```

## 🚨 Emergency Password Recovery

### Reset Admin Password
```bash
# Emergency admin password reset
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:emergency_admin_pass' | chpasswd
echo 'Admin password reset to: emergency_admin_pass'
"
```

### Reset All Passwords
```bash
# Emergency password reset for all users
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:emergency_admin_pass' | chpasswd
echo 'user1:emergency_user_pass' | chpasswd
echo 'user2:emergency_user_pass' | chpasswd
echo 'user3:emergency_user_pass' | chpasswd
echo 'user4:emergency_user_pass' | chpasswd
echo 'user5:emergency_user_pass' | chpasswd
echo 'root:emergency_root_pass' | chpasswd
echo 'All passwords reset to emergency values'
"
```

## 📊 Password Monitoring

### Password Change Log
```bash
# Monitor password changes
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'password changed' /var/log/auth.log
"
```

### Failed Login Monitoring
```bash
# Monitor failed login attempts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Failed password' /var/log/auth.log | tail -20
"
```

### Account Lockout Monitoring
```bash
# Monitor account lockouts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
grep 'Account locked' /var/log/auth.log
"
```

## 🔗 Related Topics

- **[User Accounts](user-accounts.md)** - User account management
- **[SSH Key Setup](ssh-keys.md)** - SSH key authentication setup
- **[Environment Variables](../administration/environment-variables.md)** - Password configuration via environment variables
- **[Security Overview](../security/security-overview.md)** - Security best practices
- **[SSH Access](../remote-access/ssh-access.md)** - SSH access and authentication

## 📋 Best Practices

1. **Change default passwords** immediately after first login
2. **Use strong, unique passwords** for each account
3. **Regular password rotation** (every 90 days)
4. **Monitor failed login attempts** for security
5. **Use SSH keys** instead of passwords when possible
6. **Implement password policies** for complexity requirements
7. **Keep password recovery procedures** documented

## ⚠️ Important Notes

- **Never share passwords** or commit them to version control
- **Use environment variables** for automated password management
- **Monitor password changes** for security auditing
- **Have emergency recovery procedures** ready
- **Regular security audits** of password policies

 