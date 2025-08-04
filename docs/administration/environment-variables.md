# Environment Variables Configuration

Comprehensive guide for configuring NazDocker Lab using environment variables.

## 📋 Overview

The lab uses environment variables for secure, flexible configuration. This approach:
- Keeps sensitive data out of version control
- Enables easy configuration changes without rebuilding
- Provides a template (`.env.example`) for new deployments

## 🔧 Setup

### 1. Create Environment File
```bash
# Copy the template file
cp .env.example .env

# Edit with your values
nano .env
# or
vim .env
```

### 2. Available Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `PLAYIT_SECRET_KEY` | Playit.gg secret key for public tunneling | - | Yes |
| `ADMIN_PASSWORD` | Password for admin user | `admin123` | No |
| `USER_PASSWORD` | Password for user1-user5 | `user123` | No |
| `ROOT_PASSWORD` | Password for root user | `root123` | No |
| `SSH_PORT` | SSH port mapping | `2222` | No |

### 3. Security Best Practices

- **Never commit** `.env` files to version control
- **Use strong passwords** for all user accounts
- **Rotate credentials** regularly
- **Use SSH keys** instead of passwords when possible
- **Monitor access logs** for suspicious activity

## 🔍 Validation

### Check Configuration
```bash
# View resolved configuration
docker-compose config

# Check specific variables
docker-compose config | grep PLAYIT_SECRET_KEY
docker-compose config | grep -E "(ADMIN_PASSWORD|USER_PASSWORD|ROOT_PASSWORD)"

# Validate without starting containers
docker-compose config --quiet

# Export configuration for review
docker-compose config > resolved-config.yml
```

### Troubleshooting Configuration
```bash
# Check if .env file exists
ls -la .env

# Verify .env file syntax
cat .env | grep -v "^#" | grep -v "^$"

# Check if variables are loaded
docker-compose config | grep -E "(PLAYIT_SECRET_KEY|ADMIN_PASSWORD|USER_PASSWORD|ROOT_PASSWORD)"

# Recreate .env file if corrupted
cp .env.example .env
```

## 🔄 Updating Configuration

### Method 1: Environment File (Recommended)
```bash
# Edit .env file
nano .env

# Update values
PLAYIT_SECRET_KEY=your_new_secret_key_here
ADMIN_PASSWORD=your_new_admin_password
USER_PASSWORD=your_new_user_password

# Restart container
docker-compose -f docker-compose.ubuntu.yml down && docker-compose -f docker-compose.ubuntu.yml up -d
```

### Method 2: Environment Variable
```bash
# Stop container
docker-compose -f docker-compose.ubuntu.yml down

# Set environment variable
export PLAYIT_SECRET_KEY=your_new_secret_key_here

# Start with new key
docker-compose -f docker-compose.ubuntu.yml up -d
```

### Method 3: Dockerfile
```dockerfile
# In Dockerfile.ubuntu
ENV PLAYIT_SECRET_KEY=your_secret_key_here
ENV ADMIN_PASSWORD=your_admin_password
ENV USER_PASSWORD=your_user_password
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

## 🌐 Playit.gg Configuration

### Setting Up Tunneling
1. **Get Secret Key**: Sign up at [playit.gg](https://playit.gg) and get your secret key
2. **Configure**: Add your secret key to `.env`:
   ```bash
   PLAYIT_SECRET_KEY=your_secret_key_here
   ```
3. **Restart**: Restart the container to apply changes
4. **Verify**: Check logs for tunnel URL

### Troubleshooting Tunnel Issues
```bash
# Check if secret key is loaded
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu env | grep PLAYIT

# Restart playit.gg service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu pkill playit-agent

# Check tunnel connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com
```

## 🔗 Related Topics

- **[Container Management](container-management.md)** - Managing Docker containers
- **[User Management](../user-management/user-accounts.md)** - User account configuration
- **[SSH Key Setup](../user-management/ssh-keys.md)** - Secure authentication
- **[Health Monitoring](health-monitoring.md)** - System monitoring
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common configuration issues

## 📝 Example .env File

```bash
# Required: Playit.gg secret key for public access
PLAYIT_SECRET_KEY=your_playit_secret_key_here

# User passwords (change these!)
ADMIN_PASSWORD=your_admin_password_here
USER_PASSWORD=your_user_password_here
ROOT_PASSWORD=your_root_password_here

# Optional: SSH port mapping
SSH_PORT=2222
```

 