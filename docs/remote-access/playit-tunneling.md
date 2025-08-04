# Playit.gg Tunneling

Complete guide for setting up and managing Playit.gg tunneling for public SSH access.

## 🌐 Overview

Playit.gg provides secure tunneling that allows public SSH access to your NazDocker Lab environment without exposing your local network.

## 🔧 Setup

### 1. Get Playit.gg Secret Key
1. **Sign up** at [playit.gg](https://playit.gg)
2. **Create a tunnel** for SSH access
3. **Copy your secret key** from the dashboard

### 2. Configure Environment
```bash
# Edit .env file
PLAYIT_SECRET_KEY=your_secret_key_here

# Restart container to apply changes
docker-compose -f docker-compose.ubuntu.yml down && docker-compose -f docker-compose.ubuntu.yml up -d
```

### 3. Verify Tunnel Status
```bash
# Check tunnel logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit\|tunnel\|url"

# Follow logs in real-time
docker-compose -f docker-compose.ubuntu.yml logs -f lab-environment-ubuntu

# Check playit.gg process
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep playit
```

## 🔍 Tunnel Management

### Check Tunnel Status
```bash
# View tunnel logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit\|tunnel\|url"

# Follow logs in real-time
docker-compose -f docker-compose.ubuntu.yml logs -f lab-environment-ubuntu

# Check playit.gg process
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep playit
```

### Update Playit.gg Secret Key

#### Method 1: Environment File (Recommended)
```bash
# Edit .env file
nano .env

# Update the secret key
PLAYIT_SECRET_KEY=your_new_secret_key_here

# Restart container
docker-compose -f docker-compose.ubuntu.yml down && docker-compose -f docker-compose.ubuntu.yml up -d
```

#### Method 2: Environment Variable
```bash
# Stop container
docker-compose -f docker-compose.ubuntu.yml down

# Set environment variable
export PLAYIT_SECRET_KEY=your_new_secret_key_here

# Start with new key
docker-compose -f docker-compose.ubuntu.yml up -d
```

#### Method 3: Dockerfile
```dockerfile
# In Dockerfile.ubuntu
ENV PLAYIT_SECRET_KEY=your_secret_key_here
```

## 🔌 Connecting via Tunnel

### Get Tunnel URL
```bash
# Check logs for tunnel URL
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "url\|tunnel"

# Example output:
# [INFO] Tunnel URL: your-lab.playit.gg:12345
```

### SSH Connection
```bash
# Connect via tunnel URL
ssh admin@your-lab.playit.gg -p 12345

# Connect to other users
ssh user1@your-lab.playit.gg -p 12345
ssh user2@your-lab.playit.gg -p 12345
# ... etc
```

### SSH Config for Tunnel
```bash
# Add to ~/.ssh/config
Host nazdocker-tunnel
    HostName your-lab.playit.gg
    Port 12345
    User admin
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

## 🛠️ Troubleshooting

### Tunnel Won't Start
```bash
# Check if secret key is loaded
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu env | grep PLAYIT

# Restart playit.gg service
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu pkill playit-agent

# Check tunnel connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com
```

### Connection Issues
```bash
# Test tunnel connectivity
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping google.com

# Check DNS resolution
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu nslookup google.com

# Check network interfaces
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ifconfig
```

### Secret Key Issues
```bash
# Verify secret key is set
docker-compose -f docker-compose.ubuntu.yml config | grep PLAYIT_SECRET_KEY

# Check if key is loaded in container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu env | grep PLAYIT

# Recreate .env file if needed
cp .env.example .env
# Edit with your secret key
```

## 🔧 Advanced Configuration

### Custom Tunnel Settings
```bash
# Access container
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash

# Check playit.gg configuration
cat /etc/playit/playit.conf

# Restart playit.gg with custom settings
pkill playit-agent
playit-agent --config /etc/playit/playit.conf
```

### Multiple Tunnels
```bash
# Set up multiple tunnel configurations
# Edit .env file with multiple keys
PLAYIT_SECRET_KEY_SSH=your_ssh_tunnel_key
PLAYIT_SECRET_KEY_WEB=your_web_tunnel_key
```

## 📊 Monitoring

### Tunnel Status Monitoring
```bash
#!/bin/bash
# tunnel-status.sh

echo "=== Playit.gg Tunnel Status ==="
echo ""

echo "1. Tunnel Process:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep playit
echo ""

echo "2. Recent Tunnel Logs:"
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit\|tunnel" | tail -10
echo ""

echo "3. Network Connectivity:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ping -c 1 google.com
echo ""

echo "4. Environment Variables:"
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu env | grep PLAYIT
echo ""
```

### Tunnel Health Check
```bash
#!/bin/bash
# tunnel-health.sh

# Check if tunnel is active
TUNNEL_ACTIVE=$(docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep playit | wc -l)

if [ "$TUNNEL_ACTIVE" -gt 0 ]; then
    echo "✅ Tunnel is active"
else
    echo "❌ Tunnel is not running"
fi

# Check for tunnel URL in logs
TUNNEL_URL=$(docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "url" | tail -1)

if [ -n "$TUNNEL_URL" ]; then
    echo "✅ Tunnel URL found: $TUNNEL_URL"
else
    echo "❌ No tunnel URL found in logs"
fi
```

## 🔐 Security Considerations

### Tunnel Security
- **Use HTTPS** for tunnel management when possible
- **Rotate secret keys** regularly
- **Monitor tunnel logs** for suspicious activity
- **Use strong authentication** for SSH access
- **Limit tunnel access** to necessary users only

### Best Practices
```bash
# Regular tunnel health checks
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu ps aux | grep playit

# Monitor tunnel logs
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit"

# Check for unauthorized access
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu tail -f /var/log/auth.log
```

## 🔗 Related Topics

- **[SSH Access](ssh-access.md)** - SSH connection methods
- **[Advanced Configuration](../administration/advanced-configuration.md#network-configuration)** - Network setup and troubleshooting
- **[Environment Variables](../administration/environment-variables.md)** - Configuration management
- **[Troubleshooting](../troubleshooting/common-issues.md)** - Common tunnel issues
- **[Security Overview](../security/security-overview.md)** - Security best practices

## 📋 Best Practices

1. **Keep secret keys secure** and never share them
2. **Monitor tunnel status** regularly
3. **Use strong SSH authentication** for tunnel access
4. **Regular tunnel health checks** to ensure availability
5. **Backup tunnel configuration** for recovery
6. **Monitor tunnel logs** for issues
7. **Test tunnel connectivity** regularly

## ⚠️ Important Notes

- **Tunnel URLs may change** when restarting the container
- **Check logs regularly** for tunnel status updates
- **Use SSH keys** instead of passwords for tunnel access
- **Monitor resource usage** as tunnels consume bandwidth
- **Keep tunnel configuration** documented and accessible

 