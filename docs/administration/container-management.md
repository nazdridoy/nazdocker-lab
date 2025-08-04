---
layout: default
title: Container Management
parent: Administration
nav_order: 1
permalink: /administration/container-management/
---

# Container Management

Complete guide for managing Docker containers in NazDocker Lab.

## 💾 Volume Management

### Separate Volume Structure

The lab environment uses separate volumes for Alpine and Ubuntu containers to ensure complete isolation and prevent data conflicts:

```
data/
├── alpine/           # Alpine container data
│   ├── admin/        # Admin user data (Alpine)
│   ├── user1/        # User1 data (Alpine)
│   ├── user2/        # User2 data (Alpine)
│   ├── user3/        # User3 data (Alpine)
│   ├── user4/        # User4 data (Alpine)
│   └── user5/        # User5 data (Alpine)
└── ubuntu/           # Ubuntu container data
    ├── admin/        # Admin user data (Ubuntu)
    ├── user1/        # User1 data (Ubuntu)
    ├── user2/        # User2 data (Ubuntu)
    ├── user3/        # User3 data (Ubuntu)
    ├── user4/        # User4 data (Ubuntu)
    └── user5/        # User5 data (Ubuntu)

logs/
├── alpine/           # Alpine container logs
└── ubuntu/           # Ubuntu container logs
```

### Benefits of Separate Volumes

- **🔒 Complete Isolation**: Alpine and Ubuntu containers have completely separate data storage
- **🚀 Concurrent Operation**: Both container types can run simultaneously without conflicts
- **📦 Easy Management**: Backup, restore, or manage data for each container type separately
- **🧹 Clean Organization**: Clear separation makes it obvious which data belongs to which container
- **🔄 Independent Scaling**: Scale Alpine and Ubuntu environments independently

### Volume Usage

- **Alpine Container**: Stores data in `./data/alpine/` and logs in `./logs/alpine/`
- **Ubuntu Container**: Stores data in `./data/ubuntu/` and logs in `./logs/ubuntu/`

## 🚀 Essential Commands

### Ubuntu Version
```bash
# Start the environment
docker-compose -f docker-compose.ubuntu.yml up -d

# Stop the environment
docker-compose -f docker-compose.ubuntu.yml down

# Restart the environment
docker-compose -f docker-compose.ubuntu.yml restart

# View logs
docker-compose -f docker-compose.ubuntu.yml logs -f

# Access container shell
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Validate configuration
docker-compose -f docker-compose.ubuntu.yml config

# Check container status
docker-compose -f docker-compose.ubuntu.yml ps
```

### Alpine Version (82% smaller)
```bash
# Start the environment
docker-compose -f docker-compose.alpine.yml up -d

# Stop the environment
docker-compose -f docker-compose.alpine.yml down

# Restart the environment
docker-compose -f docker-compose.alpine.yml restart

# View logs
docker-compose -f docker-compose.alpine.yml logs -f

# Access container shell
docker-compose -f docker-compose.alpine.yml exec lab-environment-alpine bash

# Validate configuration
docker-compose -f docker-compose.alpine.yml config

# Check container status
docker-compose -f docker-compose.alpine.yml ps
```

## 📊 Container Monitoring

### Status Checks

#### Ubuntu Version
```bash
# Check container status
docker-compose -f docker-compose.ubuntu.yml ps

# Check resource usage
docker stats student-lab-ubuntu

# Check container logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu

# Check container health
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu systemctl status ssh

# Monitor health check status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View health check configuration
docker inspect student-lab-ubuntu | grep -A 10 "Healthcheck"
```

#### Alpine Version
```bash
# Check container status
docker-compose -f docker-compose.alpine.yml ps

# Check resource usage
docker stats student-lab-alpine

# Check container logs
docker-compose -f docker-compose.alpine.yml logs lab-environment-alpine

# Check container health
docker-compose -f docker-compose.alpine.yml exec lab-environment-alpine pgrep sshd

# Monitor health check status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View health check configuration
docker inspect student-lab-alpine | grep -A 10 "Healthcheck"
```

### Resource Monitoring
```bash
# Monitor CPU and memory usage
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

# Check disk usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h

# Check memory usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu free -h
```

## 🔧 Container Operations

### View Running Containers
```bash
# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View container logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu

# Execute command in container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu <command>

# Stop and remove everything
docker-compose -f docker-compose.ubuntu.yml down -v --remove-orphans

# Check container health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View detailed health information
docker inspect student-lab-ubuntu | grep -A 20 "Health"
```

### Building Images
```bash
# Build Ubuntu image
docker-compose -f docker-compose.ubuntu.yml build

# Build Alpine image
docker-compose -f docker-compose.alpine.yml build

# Build both images
docker-compose -f docker-compose.ubuntu.yml build && docker-compose -f docker-compose.alpine.yml build

# Force rebuild (no cache)
docker-compose -f docker-compose.ubuntu.yml build --no-cache
```

### Running Both Containers Simultaneously

With separate volumes, you can run both Alpine and Ubuntu containers at the same time:

```bash
# Start both environments
docker-compose -f docker-compose.ubuntu.yml up -d
docker-compose -f docker-compose.alpine.yml up -d

# Access Ubuntu lab (port 2222)
ssh admin@localhost -p 2222

# Access Alpine lab (port 2223 - you'll need to modify SSH_PORT in .env)
ssh admin@localhost -p 2223

# Both containers use the same SSH host keys
# Stop both environments
docker-compose -f docker-compose.ubuntu.yml down
docker-compose -f docker-compose.alpine.yml down
```

## 🏥 Health Monitoring

### Health Check Overview
The container includes built-in health checks that monitor SSH service availability:

- **Interval**: 30 seconds between checks
- **Timeout**: 10 seconds maximum for each check
- **Start Period**: 40 seconds grace period after container startup
- **Retries**: 3 consecutive failures before marking as unhealthy

### Health Status Monitoring
```bash
# Check container health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View detailed health information
docker inspect student-lab | grep -A 20 "Health"

# Monitor health check logs
docker inspect student-lab | grep -A 10 "Healthcheck"

# Test health check manually
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
```

### Health Check Troubleshooting
```bash
# If container shows as unhealthy
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Restart SSH service if needed
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh restart

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config

# View health check logs
docker inspect student-lab-ubuntu | grep -A 20 "Health"
```

## 🔄 Container Lifecycle

### Startup Process
1. **Container Creation**: Docker creates container from image
2. **Startup Script**: `start.sh` executes to configure users and services
3. **SSH Service**: SSH daemon starts and begins accepting connections
4. **Health Checks**: Health monitoring begins after grace period
5. **Ready State**: Container is ready for connections

### Shutdown Process
1. **Graceful Shutdown**: Docker sends SIGTERM signal
2. **Service Stop**: SSH service stops gracefully
3. **Data Persistence**: User data in volumes is preserved
4. **Container Removal**: Container is removed (unless using `--rm`)

## 🛠️ Advanced Operations

### Container Inspection
```bash
# View container details
docker inspect student-lab-ubuntu

# View container configuration
docker inspect student-lab-ubuntu | grep -A 10 "Config"

# View container network settings
docker inspect student-lab-ubuntu | grep -A 20 "NetworkSettings"

# View container mounts
docker inspect student-lab-ubuntu | grep -A 10 "Mounts"
```

### Container Debugging
```bash
# Access container with custom shell
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu /bin/bash

# Run command in container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu whoami

# Copy files to/from container
docker cp student-lab-ubuntu:/etc/ssh/sshd_config ./sshd_config_backup
docker cp ./custom_script.sh student-lab-ubuntu:/tmp/

# View container logs in real-time
docker-compose -f docker-compose.ubuntu.yml logs -f --tail=100
```

### Performance Optimization
```bash
# Monitor resource usage
docker stats --no-stream

# Check container performance
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu top

# Monitor disk I/O
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu iostat

# Check network connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com
```

## 🧹 Cleanup Operations

### Complete Cleanup
```bash
# Stop and remove everything
docker-compose -f docker-compose.ubuntu.yml down -v --remove-orphans --rmi all

# Remove all unused Docker resources
docker system prune -a --volumes

# Verify cleanup
docker ps -a
docker network ls
docker volume ls
docker images
```

### Selective Cleanup
```bash
# Remove specific resources
docker rm -f student-lab-ubuntu
docker network rm nazdocker-lab_lab-network
docker volume rm nazdocker-lab_user-data

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune
```

## 📝 Management Scripts

### Status Check Script
```bash
#!/bin/bash
# status-check.sh

echo "=== NazDocker Lab Status ==="
echo "Container Status:"
docker-compose -f docker-compose.ubuntu.yml ps
echo ""

echo "Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "Recent Logs:"
docker-compose -f docker-compose.ubuntu.yml logs --tail=20 lab-environment-ubuntu
echo ""

echo "Resource Usage:"
docker stats --no-stream student-lab-ubuntu
echo ""

echo "User Accounts:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'"
```

### Health Monitoring Script
```bash
#!/bin/bash
# health-monitor.sh

echo "=== NazDocker Lab Health Monitor ==="
echo ""

echo "Container Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
echo ""

echo "Detailed Health Information:"
docker inspect student-lab-ubuntu | grep -A 20 "Health"
echo ""

echo "SSH Service Status:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
echo ""

echo "Recent Health Check Logs:"
docker inspect student-lab-ubuntu | grep -A 10 "Healthcheck"
```

## 🔗 Related Topics

- **[Environment Variables](environment-variables.md)** - Configuration management
- **[Health Monitoring](health-monitoring.md)** - System health and monitoring
- **[SSH Key Synchronization](ssh-key-sync.md)** - SSH key management
- **[User Management](../user-management/user-accounts.md)** - User account management
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common container issues
- **[Emergency Procedures](../troubleshooting/emergency.md)** - Emergency recovery