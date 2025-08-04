---
layout: default
title: NazDocker Lab Documentation
nav_order: 1
permalink: /
---

# NazDocker Lab Documentation

Welcome to the NazDocker Lab documentation. This modular documentation system provides comprehensive guides for managing and using the NazDocker Lab environment.

## 📚 Documentation Structure

### 🚀 Getting Started
- **[Quick Start Guide](getting-started/quick-start.md)** - Get up and running in minutes
- **[Project Structure](getting-started/project-structure.md)** - Complete project overview and file organization

### 👥 User Management
- **[User Accounts](user-management/user-accounts.md)** - User account overview and management
- **[Password Management](user-management/passwords.md)** - Password configuration and security
- **[SSH Key Setup](user-management/ssh-keys.md)** - SSH key authentication setup

### 🔧 Administration
- **[Container Management](administration/container-management.md)** - Docker container operations
- **[Environment Variables](administration/environment-variables.md)** - Configuration management
- **[Health Monitoring](administration/health-monitoring.md)** - System health and monitoring
- **[Backup and Recovery](administration/backup-recovery.md)** - Data backup and restoration
- **[Advanced Configuration](administration/advanced-configuration.md)** - Advanced customization and optimization
- **[Useful Scripts](administration/useful-scripts.md)** - Management and diagnostic scripts

### 🌐 Remote Access
- **[SSH Access](remote-access/ssh-access.md)** - Local and remote SSH connections
- **[Playit.gg Tunneling](remote-access/playit-tunneling.md)** - Public access via tunneling

### 🛠️ Development
- **[Available Tools](development/available-tools.md)** - Development tools and utilities

### 🔐 Security
- **[Security Overview](security/security-overview.md)** - Security architecture and best practices

### 🏔️ Alpine vs Ubuntu
- **[Version Comparison](alpine-ubuntu/comparison.md)** - Detailed feature comparison

### 🛡️ Troubleshooting
- **[Common Issues](troubleshooting/common-issues.md)** - Solutions to frequent problems
- **[Diagnostic Commands](troubleshooting/diagnostics.md)** - Troubleshooting commands and tools
- **[Emergency Procedures](troubleshooting/emergency.md)** - Emergency recovery procedures

### 🔧 Maintenance
- **[Regular Maintenance](maintenance/regular-maintenance.md)** - Maintenance procedures and cleanup

## 🎯 Quick Navigation

### For New Users
1. Start with [Quick Start Guide](getting-started/quick-start.md)
2. Configure your environment with [Environment Variables](administration/environment-variables.md)
3. Learn about [User Accounts](user-management/user-accounts.md)

### For Administrators
1. Review [Container Management](administration/container-management.md)
2. Set up [Health Monitoring](administration/health-monitoring.md)
3. Configure [Backup and Recovery](administration/backup-recovery.md)
4. Explore [Advanced Configuration](administration/advanced-configuration.md)
5. Use [Useful Scripts](administration/useful-scripts.md) for automation

### For Developers
1. Explore [Available Tools](development/available-tools.md)
2. Learn about [Alpine vs Ubuntu Comparison](alpine-ubuntu/comparison.md)
3. Understand [Project Structure](getting-started/project-structure.md)

### For Troubleshooting
1. Check [Common Issues](troubleshooting/common-issues.md)
2. Use [Diagnostic Commands](troubleshooting/diagnostics.md)
3. Follow [Emergency Procedures](troubleshooting/emergency.md) if needed

### For Maintenance
1. Follow [Regular Maintenance](maintenance/regular-maintenance.md) procedures
2. Use [Useful Scripts](administration/useful-scripts.md) for automation
3. Monitor [Health Status](administration/health-monitoring.md) regularly

## 📋 Project Overview

NazDocker Lab is a secure, containerized development environment that provides:

- **Multi-User Environment**: 6 pre-configured user accounts
- **Public SSH Access**: Secure remote access via playit.gg tunneling
- **Development Tools**: Python 3.x, Node.js, Git, and essential utilities
- **Persistent Storage**: User data persists across container restarts with separate volumes for Alpine and Ubuntu
- **Health Monitoring**: Built-in health checks for SSH service availability
- **Alpine & Ubuntu Support**: Choose between lightweight Alpine or full Ubuntu with isolated data storage

## 🔗 Related Resources

- **[Main README](../README.md)** - Project overview and quick start
- **[MANAGEMENT.md](../MANAGEMENT.md)** - Legacy comprehensive guide (being replaced)
- **[GitHub Repository](https://github.com/nazdridoy/nazdocker-lab)** - Source code and issues
- **[Docker Documentation](https://docs.docker.com/)** - Docker basics and advanced topics
