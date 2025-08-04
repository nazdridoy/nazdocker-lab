---
layout: default
title: Quick Start Guide
parent: Getting Started
nav_order: 1
permalink: /getting-started/quick-start/
---

# Quick Start Guide

Get NazDocker Lab up and running in minutes with this quick start guide.

## 🚀 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)
- [Git](https://git-scm.com/downloads)

## ⚡ Quick Setup

### 1. Clone and Navigate
```bash
git clone https://github.com/nazdridoy/nazdocker-lab.git
cd nazdocker-lab
```

### 2. Set Up Environment
```bash
# Create separate data directories for Alpine and Ubuntu
mkdir -p data/{alpine,ubuntu}/{admin,user1,user2,user3,user4,user5}
mkdir -p logs/{alpine,ubuntu}

# Configure environment variables
cp .env.example .env
# Edit .env with your configuration (see [Configuration Guide](../administration/environment-variables.md))
```

### 3. Start the Environment

**Ubuntu Version (Recommended for Development):**
```bash
docker-compose -f docker-compose.ubuntu.yml up -d
```

**Alpine Version (82% smaller, Recommended for Production):**
```bash
docker-compose -f docker-compose.alpine.yml up -d
```

### 4. Access the Lab
```bash
# Local SSH access
ssh admin@localhost -p 2222
# Password: admin123
```

## 👥 Quick User Reference

| Username | Password | Sudo Access | Purpose |
|----------|----------|-------------|---------|
| `admin` | `admin123` | ✅ Yes | Administrative tasks |
| `user1` | `user123` | ❌ No | Regular development |
| `user2` | `user123` | ❌ No | Regular development |
| `user3` | `user123` | ❌ No | Regular development |
| `user4` | `user123` | ❌ No | Regular development |
| `user5` | `user123` | ❌ No | Regular development |
| `root` | `root123` | ✅ Yes | System administration |

## 🔧 Essential Commands

### Container Management
```bash
# Start environment
docker-compose -f docker-compose.ubuntu.yml up -d

# Stop environment
docker-compose -f docker-compose.ubuntu.yml down

# View logs
docker-compose -f docker-compose.ubuntu.yml logs -f

# Access container shell
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu bash
```

### Health Monitoring
```bash
# Check container status
docker-compose -f docker-compose.ubuntu.yml ps

# Check health status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"
```

## 🌐 Remote Access

### Local Access
```bash
ssh admin@localhost -p 2222
ssh user1@localhost -p 2222
# ... etc
```

### Public Access (via Playit.gg)
1. Set your `PLAYIT_SECRET_KEY` in `.env`
2. Check tunnel status: `docker-compose logs | grep -i "playit"`
3. Connect via the provided public URL

## 🛠️ What's Available

- **Python 3.x** with pip
- **Node.js** with npm
- **Git** for version control
- **SSH** server for remote access
- **Development utilities** (curl, jq, ping, etc.)

## 🔗 Next Steps

1. **[Configure Environment Variables](../administration/environment-variables.md)** - Set up passwords and tunneling
2. **[Learn User Management](../user-management/user-accounts.md)** - Manage user accounts
3. **[Set Up SSH Keys](../user-management/ssh-keys.md)** - Secure authentication
4. **[Explore Development Tools](../development/available-tools.md)** - Available development utilities

## 🆘 Need Help?

- **[Common Issues](../troubleshooting/common-issues.md)** - Solutions to frequent problems
- **[Diagnostic Commands](../troubleshooting/diagnostics.md)** - Troubleshooting tools
- **[Emergency Procedures](../troubleshooting/emergency.md)** - Emergency recovery