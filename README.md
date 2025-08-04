# NazDocker Lab

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://www.docker.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange.svg)](https://ubuntu.com/)

A secure, containerized development environment for educational and development purposes. This project provides a Docker-based lab environment with SSH access, multiple user accounts, and development tools, designed for learning, testing, and development workflows.

## 🚀 Features

- **🔐 Multi-User Environment**: 6 pre-configured user accounts (admin + 5 regular users)
- **🌐 Public SSH Access**: Secure remote access via playit.gg tunneling
- **🛠️ Development Tools**: Python 3.x, Node.js, Git, and essential utilities
- **💾 Persistent Storage**: User data persists across container restarts
- **⚙️ Runtime Configuration**: Environment-based configuration management
- **🔒 Security Focused**: Proper user isolation and SSH key support
- **🏥 Health Monitoring**: Built-in health checks for SSH service availability

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10 or higher)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0 or higher)
- [Git](https://git-scm.com/downloads) for cloning the repository

## 🏃‍♂️ Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/nazdridoy/nazdocker-lab.git
cd nazdocker-lab
```

### 2. Set Up Environment
```bash
# Create data directories
mkdir -p data/{admin,user1,user2,user3,user4,user5}

# Configure environment variables
cp .env.example .env
# Edit .env with your configuration
```

### 3. Start the Environment
```bash
docker-compose up -d
```

### 4. Access the Lab
```bash
# Local SSH access
ssh admin@localhost -p 2222
# Password: admin123
```

## 👥 User Accounts

| Username | Default Password | Sudo Access | Purpose |
|----------|------------------|-------------|---------|
| `admin` | `admin123` | ✅ Yes | Administrative tasks |
| `user1` | `user123` | ❌ No | Regular development |
| `user2` | `user123` | ❌ No | Regular development |
| `user3` | `user123` | ❌ No | Regular development |
| `user4` | `user123` | ❌ No | Regular development |
| `user5` | `user123` | ❌ No | Regular development |
| `root` | `root123` | ✅ Yes | System administration |

## 🔧 Configuration

### Environment Variables

The lab uses environment variables for secure configuration. Copy `.env.example` to `.env` and customize:

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

### Security Best Practices

- **Change default passwords** immediately after first login
- **Use SSH keys** instead of password authentication when possible
- **Never commit** your `.env` file to version control
- **Regular updates** of the base image and installed packages

## 🌐 Remote Access

### Local Access
```bash
# SSH to any user
ssh admin@localhost -p 2222
ssh user1@localhost -p 2222
# ... etc
```

### Public Access via Playit.gg

The environment includes playit.gg tunneling for public SSH access:

1. **Configure playit.gg**: Set your secret key in `.env`
2. **Check tunnel status**: Monitor container logs for tunnel URL
3. **Connect remotely**: Use the provided public URL

```bash
# Check tunnel status
docker-compose logs lab-environment | grep -i "playit\|tunnel"

# Connect via public URL (example)
ssh admin@your-tunnel-url.playit.gg -p 12345
```

## 🛠️ Available Tools

### Development Tools
- **Python 3.x** with pip package manager
- **Node.js** with npm package manager
- **Git** for version control
- **SSH** server for remote access

### System Utilities
- **curl** for HTTP requests
- **jq** for JSON processing
- **ping** for network testing
- **ifconfig** for network configuration
- **apt** package manager

## 📁 Project Structure

```
nazdocker-lab/
├── Dockerfile              # Container definition with health checks
├── start.sh               # Modularized startup script
├── docker-compose.yml      # Docker Compose orchestration
├── .env.example           # Environment variables template
├── README.md              # This file
├── MANAGEMENT.md          # Detailed management guide
├── LICENSE                # GPL v3 license
├── data/                  # Persistent user data
│   ├── admin/            # Admin home directory
│   ├── user1/            # User1 home directory
│   ├── user2/            # User2 home directory
│   ├── user3/            # User3 home directory
│   ├── user4/            # User4 home directory
│   └── user5/            # User5 home directory
└── logs/                 # Application logs
```

## 🔄 Development Workflow

1. **Start environment**: `docker-compose up -d`
2. **SSH into lab**: `ssh admin@localhost -p 2222`
3. **Develop**: Work in your persistent home directory
4. **Install packages**: Use `sudo apt-get install` (admin only)
5. **Stop when done**: `docker-compose down`

## 🛡️ Security Considerations

### Default Configuration
- All users have password authentication enabled
- SSH keys are not configured by default
- Default passwords should be changed immediately

### Recommended Security Measures
1. **Change all default passwords** after first login
2. **Configure SSH key authentication** for better security
3. **Use strong, unique passwords** for each user
4. **Regular security updates** of the base image
5. **Monitor access logs** for suspicious activity

## 🏥 Health Monitoring

The container includes built-in health checks that monitor SSH service availability:

- **Health Check Interval**: 30 seconds
- **Timeout**: 10 seconds per check
- **Start Period**: 40 seconds grace period after container startup
- **Retries**: 3 consecutive failures before marking as unhealthy

### Health Status
- **Healthy**: SSH service is running and accepting connections
- **Unhealthy**: SSH service is stopped or not responding
- **Starting**: Container is in the grace period after startup

### Monitoring Health Status
```bash
# Check container health status
docker ps

# View detailed health information
docker inspect student-lab | grep -A 20 "Health"

# Monitor health check logs
docker inspect student-lab | grep -A 10 "Healthcheck"
```

## 📚 Documentation

- **[MANAGEMENT.md](MANAGEMENT.md)**: Comprehensive management guide
- **[Docker Documentation](https://docs.docker.com/)**: Docker basics
- **[SSH Documentation](https://www.openssh.com/manual.html)**: SSH configuration

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup
```bash
# Clone your fork
git clone https://github.com/your-username/nazdocker-lab.git
cd nazdocker-lab

# Add upstream remote
git remote add upstream https://github.com/nazdridoy/nazdocker-lab.git

# Create feature branch
git checkout -b feature/your-feature-name
```

## 🐛 Troubleshooting

### Common Issues

**Container won't start:**
```bash
# Check logs
docker-compose logs

# Validate configuration
docker-compose config
```

**SSH connection refused:**
```bash
# Check container status
docker-compose ps

# Check SSH service
docker-compose exec lab-environment service ssh status
```

**Environment variables not loading:**
```bash
# Verify .env file exists
ls -la .env

# Check variable resolution
docker-compose config | grep -E "(PLAYIT_SECRET_KEY|ADMIN_PASSWORD)"
```

For more detailed troubleshooting, see [MANAGEMENT.md](MANAGEMENT.md).

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Docker](https://www.docker.com/) for containerization technology
- [Ubuntu](https://ubuntu.com/) for the base operating system
- [Playit.gg](https://playit.gg/) for tunneling services
- [OpenSSH](https://www.openssh.com/) for secure shell access

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/nazdridoy/nazdocker-lab/issues)
- **Discussions**: [GitHub Discussions](https://github.com/nazdridoy/nazdocker-lab/discussions)
- **Documentation**: [MANAGEMENT.md](MANAGEMENT.md)

---

**Note**: This is a development and educational tool. Always follow security best practices and change default credentials before use in production environments. 