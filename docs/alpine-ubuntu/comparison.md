---
layout: default
title: Alpine vs Ubuntu Comparison
parent: Alpine vs Ubuntu
nav_order: 1
permalink: /alpine-ubuntu/comparison/
---

# Alpine vs Ubuntu Comparison

Detailed comparison between Alpine and Ubuntu versions of NazDocker Lab.

## 📊 Size Comparison

| Version | Base Image | Final Size | Size Reduction |
|---------|------------|------------|----------------|
| **Ubuntu** | `ubuntu:24.04` | 1.05GB | - |
| **Alpine** | `alpine:3.22` | 189MB | **82% smaller** |

## ⚡ Performance Benefits

### Build Performance
- **Build Time**: Alpine builds ~50% faster
- **Download Time**: Alpine downloads ~80% faster
- **Storage Savings**: Alpine saves 861MB per container

### Runtime Performance
- **Startup Time**: Alpine starts ~30% faster
- **Memory Usage**: Alpine uses ~40% less memory
- **Disk I/O**: Alpine has faster disk operations

## 🔧 Technical Differences

### Package Management

| Aspect | Ubuntu | Alpine |
|--------|--------|--------|
| **Package Manager** | `apt` | `apk` |
| **Update Command** | `apt-get update` | `apk update` |
| **Install Command** | `apt-get install` | `apk add` |
| **Remove Command** | `apt-get remove` | `apk del` |
| **Search Command** | `apt search` | `apk search` |
| **Python Package Manager** | `uv` (installed via installer) | `uv` (via apk) |

### Service Management

| Aspect | Ubuntu | Alpine |
|--------|--------|--------|
| **Service Command** | `service ssh status` | `pgrep sshd` |
| **Start Service** | `service ssh start` | `rc-service sshd start` |
| **Stop Service** | `service ssh stop` | `rc-service sshd stop` |
| **Restart Service** | `service ssh restart` | `rc-service sshd restart` |

### User Management

| Aspect | Ubuntu | Alpine |
|--------|--------|--------|
| **Sudo Group** | `sudo` | `wheel` |
| **Add to Sudo** | `usermod -aG sudo` | `addgroup admin wheel` |
| **Sudoers Config** | `%sudo ALL=(ALL:ALL) ALL` | `%wheel ALL=(ALL) ALL` |
| **Check Sudo** | `getent group sudo` | `getent group wheel` |

## 💾 Volume Management

### Separate Volume Structure

Both Alpine and Ubuntu versions use separate volume directories to ensure complete isolation:

- **Alpine Container**: Data in `./data/alpine/`
- **Ubuntu Container**: Data in `./data/ubuntu/`

This allows both containers to run simultaneously without data conflicts.

### Benefits of Separate Volumes

- **🔒 Complete Isolation**: Alpine and Ubuntu containers have completely separate data storage
- **🚀 Concurrent Operation**: Both container types can run simultaneously without conflicts
- **📦 Easy Management**: Backup, restore, or manage data for each container type separately
- **🧹 Clean Organization**: Clear separation makes it obvious which data belongs to which container
- **🔄 Independent Scaling**: Scale Alpine and Ubuntu environments independently

## 🚀 Commands Comparison

### Container Management

#### Ubuntu Version
```bash
# Start environment
docker-compose -f docker-compose.ubuntu.yml up -d

# Stop environment
docker-compose -f docker-compose.ubuntu.yml down

# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Check health
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
```

#### Alpine Version
```bash
# Start environment
docker-compose -f docker-compose.alpine.yml up -d

# Stop environment
docker-compose -f docker-compose.alpine.yml down

# Access container
docker-compose -f docker-compose.alpine.yml exec lab-environment-alpine bash

# Check health
docker-compose -f docker-compose.alpine.yml exec lab-environment-alpine pgrep sshd
```

### Running Both Containers Simultaneously
```bash
# Start both environments
docker-compose -f docker-compose.ubuntu.yml up -d
docker-compose -f docker-compose.alpine.yml up -d

# Access Ubuntu lab (port 2222)
ssh admin@localhost -p 2222

# Access Alpine lab (port 2223 - modify SSH_PORT in .env)
ssh admin@localhost -p 2223

# Both containers use the same SSH host keys
# Stop both environments
docker-compose -f docker-compose.ubuntu.yml down
docker-compose -f docker-compose.alpine.yml down
```

### Python Development Tools

Both Alpine and Ubuntu containers include modern Python development tools:

#### Ubuntu Container
```bash
# uv is installed via official installer
uv --version
uvx --version

# Python development workflow
uv init myproject
uv add requests flask
uv run myproject/main.py
uvx ruff check
```

#### Alpine Container
```bash
# uv is installed via apk package manager
uv --version
uvx --version

# Python development workflow
uv init myproject
uv add requests flask
uv run myproject/main.py
uvx ruff check
```

### Package Installation

#### Ubuntu
```bash
# Update package list
apt-get update

# Install packages
apt-get install -y package_name

# Remove packages
apt-get remove package_name

# Search packages
apt search package_name
```

#### Alpine
```bash
# Update package list
apk update

# Install packages
apk add package_name

# Remove packages
apk del package_name

# Search packages
apk search package_name
```

## 🛡️ Security Comparison

### Attack Surface
- **Alpine**: Smaller attack surface due to minimal base image
- **Ubuntu**: Larger attack surface due to more packages and services

### Security Updates
- **Alpine**: Frequent security updates, smaller patches
- **Ubuntu**: Regular security updates, larger patches

### Default Configuration
- **Alpine**: Minimal default configuration
- **Ubuntu**: More comprehensive default configuration

## 🎯 Use Case Recommendations

### Use Alpine When:
- **Resource constraints** are a concern
- **Fast deployments** are needed
- **Security is a priority** (smaller attack surface)
- **Production environments** where size matters
- **CI/CD pipelines** where build speed is important
- **Microservices** architecture
- **Edge computing** with limited resources
- **Python development** with `uv` in minimal environment

### Use Ubuntu When:
- **Maximum compatibility** is needed
- **Familiar environment** is preferred
- **Specific Ubuntu packages** are required
- **Development/testing** environments
- **Legacy applications** that depend on Ubuntu
- **Full system utilities** are needed
- **Educational purposes** where familiarity matters
- **Python development** with latest `uv` features

## 📈 Resource Limits

### Current Configuration
Both versions are configured with optimized resource limits:

| Resource | Limit | Reservation |
|----------|-------|-------------|
| **CPU** | 2.0 cores | 1.0 core |
| **Memory** | 2GB | 1GB |
| **Network** | Bridge | Standard |
| **Storage** | Persistent volumes | User data |

### Performance Metrics

| Metric | Alpine | Ubuntu | Improvement |
|--------|--------|--------|-------------|
| **Startup Time** | ~15s | ~22s | 32% faster |
| **Memory Usage** | ~120MB | ~200MB | 40% less |
| **Build Time** | ~45s | ~90s | 50% faster |
| **Image Size** | 189MB | 1.05GB | 82% smaller |

## 🔧 Customization Differences

### Adding Packages

#### Ubuntu
```dockerfile
# In Dockerfile.ubuntu
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*
```

#### Alpine
```dockerfile
# In Dockerfile.alpine
RUN apk update && apk add \
    package1 \
    package2 \
    && rm -rf /var/cache/apk/*
```

### Service Configuration

#### Ubuntu
```bash
# Service management
service ssh status
service ssh restart
systemctl status ssh
```

#### Alpine
```bash
# Service management
pgrep sshd
rc-service sshd restart
ps aux | grep sshd
```

## 🔍 Health Check Differences

### Ubuntu Health Check
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD service ssh status || exit 1
```

### Alpine Health Check
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD pgrep sshd || exit 1
```

## 📋 Migration Guide

### From Ubuntu to Alpine
1. **Update commands** to use Alpine syntax
2. **Replace apt** with apk commands
3. **Update service management** to use Alpine methods
4. **Test compatibility** of your applications
5. **Update scripts** that use Ubuntu-specific commands

### From Alpine to Ubuntu
1. **Update commands** to use Ubuntu syntax
2. **Replace apk** with apt commands
3. **Update service management** to use systemctl/service
4. **Test compatibility** of your applications
5. **Update scripts** that use Alpine-specific commands

## 🔗 Related Topics

- **[Container Management](../administration/container-management.md)** - Alpine and Ubuntu container operations
- **[SSH Key Synchronization](../administration/ssh-key-sync.md)** - SSH key management
- **[Advanced Configuration](../administration/advanced-configuration.md)** - System optimization and configuration
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common issues