# Common Issues and Solutions

Quick solutions to the most frequent problems encountered with NazDocker Lab.

## 🚨 Container Won't Start

### Check Logs
```bash
# View detailed logs
docker-compose -f docker-compose.ubuntu.yml logs

# Follow logs in real-time
docker-compose -f docker-compose.ubuntu.yml logs -f

# Check specific container logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu
```

### Common Causes and Solutions

#### 1. Port Already in Use
```bash
# Check if port 2222 is in use
netstat -tulpn | grep :2222
lsof -i :2222

# Kill process using the port
sudo kill -9 <PID>

# Or change port in docker-compose.ubuntu.yml
# ports:
#   - "2223:22"  # Use different port
```

#### 2. Insufficient Disk Space
```bash
# Check disk space
df -h

# Clean up Docker
docker system prune -a

# Remove unused images
docker image prune -a
```

#### 3. Docker Service Not Running
```bash
# Check Docker service status
sudo systemctl status docker

# Start Docker service
sudo systemctl start docker

# Enable Docker service
sudo systemctl enable docker
```

## 🔌 SSH Connection Issues

### Connection Refused
```bash
# Check if container is running
docker-compose -f docker-compose.ubuntu.yml ps

# Check SSH service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Restart SSH service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh restart

# Check port mapping
docker port student-lab-ubuntu
```

### Authentication Failed
```bash
# Check user accounts
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'
"

# Reset password
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
echo 'admin:admin123' | chpasswd
"

# Check SSH configuration
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu cat /etc/ssh/sshd_config
```

### Wrong Port
```bash
# Check which port is mapped
docker port student-lab-ubuntu

# Connect to correct port
ssh admin@localhost -p <CORRECT_PORT>
```

## 🌐 Network Connectivity Issues

### Container Can't Reach Internet
```bash
# Test network connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com

# Check DNS resolution
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu nslookup google.com

# Check network interfaces
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig
```

### Playit.gg Tunnel Issues
```bash
# Check if secret key is loaded
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu env | grep PLAYIT

# Restart playit.gg service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu pkill playit-agent

# Check tunnel logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit"
```

## ⚙️ Environment Variable Issues

### Variables Not Loading
```bash
# Check if .env file exists
ls -la .env

# Verify .env file syntax
cat .env | grep -v "^#" | grep -v "^$"

# Check if variables are loaded
docker-compose -f docker-compose.ubuntu.yml config | grep -E "(PLAYIT_SECRET_KEY|ADMIN_PASSWORD|USER_PASSWORD|ROOT_PASSWORD)"

# Recreate .env file if corrupted
cp .env.example .env
```

### Invalid Configuration
```bash
# Validate configuration
docker-compose -f docker-compose.ubuntu.yml config

# Check specific variables
docker-compose -f docker-compose.ubuntu.yml config | grep PLAYIT_SECRET_KEY

# Export configuration for review
docker-compose -f docker-compose.ubuntu.yml config > resolved-config.yml
```

## 💾 Data Persistence Issues

### User Data Not Persisting
```bash
# Check volume mounts
docker inspect student-lab-ubuntu | grep -A 10 "Mounts"

# Check data directory permissions
ls -la data/

# Recreate data directories
mkdir -p data/{admin,user1,user2,user3,user4,user5}
chmod 755 data/
```

### Permission Issues
```bash
# Fix data directory permissions
sudo chown -R $USER:$USER data/
chmod 755 data/

# Fix container permissions
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash -c "
chown -R admin:admin /home/admin
chown -R user1:user1 /home/user1
# ... repeat for all users
"
```

## 🏥 Health Check Issues

### Container Shows as Unhealthy
```bash
# Check health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# View health check logs
docker inspect student-lab-ubuntu | grep -A 20 "Health"

# Test SSH service manually
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status

# Restart SSH service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh restart
```

### Health Check Configuration
```bash
# View health check configuration
docker inspect student-lab-ubuntu | grep -A 10 "Healthcheck"

# Test health check command
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
```

## 🔧 Performance Issues

### High Resource Usage
```bash
# Check resource usage
docker stats student-lab-ubuntu

# Check container performance
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu top

# Check disk usage
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu df -h
```

### Slow Startup
```bash
# Check startup logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "start"

# Monitor startup process
docker-compose -f docker-compose.ubuntu.yml logs -f lab-environment-ubuntu
```

## 🧹 Cleanup Issues

### Container Won't Remove
```bash
# Force remove container
docker rm -f student-lab-ubuntu

# Remove with volumes
docker-compose -f docker-compose.ubuntu.yml down -v

# Remove all related resources
docker-compose -f docker-compose.ubuntu.yml down -v --remove-orphans --rmi all
```

### Image Cleanup
```bash
# Remove unused images
docker image prune -a

# Remove all images
docker rmi $(docker images -q)

# Clean up everything
docker system prune -a --volumes
```

## 🔍 Diagnostic Commands

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

## 🔗 Related Topics

- **[Diagnostic Commands](diagnostics.md)** - Advanced troubleshooting tools
- **[Emergency Procedures](emergency.md)** - Emergency recovery procedures
- **[Container Management](../administration/container-management.md)** - Container operations
- **[Health Monitoring](../administration/health-monitoring.md)** - System health monitoring
- **[Environment Variables](../administration/environment-variables.md)** - Configuration management

## 📋 Prevention Tips

1. **Regular backups** of important data
2. **Monitor resource usage** to prevent issues
3. **Keep Docker updated** for latest fixes
4. **Use health checks** to catch issues early
5. **Test changes** in a safe environment first
6. **Document customizations** for easier troubleshooting
7. **Regular cleanup** of unused resources

 