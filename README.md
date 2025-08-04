# NazDocker Lab

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://www.docker.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange.svg)](https://ubuntu.com/)
[![Alpine](https://img.shields.io/badge/Alpine-3.22-lightblue.svg)](https://alpinelinux.org/)
[![Documentation](https://img.shields.io/badge/Documentation-Complete-brightgreen.svg)](https://nazdridoy.github.io/nazdocker-lab/)

A secure, containerized development environment for educational and development purposes. This project provides a Docker-based lab environment with SSH access, multiple user accounts, and development tools, designed for learning, testing, and development workflows.

## 🚀 Features

- **🔐 Multi-User Environment**: 6 pre-configured user accounts (admin + 5 regular users)
- **🌐 Public SSH Access**: Secure remote access via playit.gg tunneling
- **🛠️ Development Tools**: Python 3.x, Node.js, Git, and essential utilities
- **💾 Persistent Storage**: User data persists across container restarts with separate volumes for Alpine and Ubuntu
- **⚙️ Runtime Configuration**: Environment-based configuration management
- **🔒 Security Focused**: Proper user isolation and SSH key support
- **🏥 Health Monitoring**: Built-in health checks for SSH service availability
- **🏔️ Alpine & Ubuntu Support**: Choose between lightweight Alpine (173MB) or full Ubuntu (968MB)

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
# Create separate data directories for Alpine and Ubuntu
mkdir -p data/{alpine,ubuntu}/{admin,user1,user2,user3,user4,user5}
mkdir -p logs/{alpine,ubuntu}

# Configure environment variables
cp .env.example .env
# Edit .env with your configuration
```

### 3. Start the Environment

Choose your preferred version:

**Ubuntu Version (Recommended for Development):**
```bash
docker-compose -f docker-compose.ubuntu.yml up -d
```

**Alpine Version (Recommended for Production - 82% smaller):**
```bash
docker-compose -f docker-compose.alpine.yml up -d
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
docker-compose -f docker-compose.ubuntu.yml logs lab-environment-ubuntu | grep -i "playit\|tunnel"

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
├── Dockerfile.ubuntu       # Ubuntu container definition with health checks
├── Dockerfile.alpine       # Alpine container definition (189MB)
├── start.sh               # Cross-platform startup script
├── docker-compose.ubuntu.yml # Ubuntu Docker Compose orchestration
├── docker-compose.alpine.yml # Alpine Docker Compose orchestration
├── .env.example           # Environment variables template
├── README.md              # This file
├── docs/                 # Modular documentation
├── LICENSE                # GPL v3 license
├── data/                  # Persistent user data (separated by container type)
│   ├── alpine/           # Alpine container data
│   │   ├── admin/        # Admin home directory (Alpine)
│   │   ├── user1/        # User1 home directory (Alpine)
│   │   ├── user2/        # User2 home directory (Alpine)
│   │   ├── user3/        # User3 home directory (Alpine)
│   │   ├── user4/        # User4 home directory (Alpine)
│   │   └── user5/        # User5 home directory (Alpine)
│   └── ubuntu/           # Ubuntu container data
│       ├── admin/        # Admin home directory (Ubuntu)
│       ├── user1/        # User1 home directory (Ubuntu)
│       ├── user2/        # User2 home directory (Ubuntu)
│       ├── user3/        # User3 home directory (Ubuntu)
│       ├── user4/        # User4 home directory (Ubuntu)
│       └── user5/        # User5 home directory (Ubuntu)
└── logs/                 # Application logs (separated by container type)
    ├── alpine/           # Alpine container logs
    └── ubuntu/           # Ubuntu container logs
```

## 🔄 Development Workflow

### Ubuntu Version (Recommended for Development)
```bash
# Start Ubuntu environment
docker-compose -f docker-compose.ubuntu.yml up -d

# SSH into lab
ssh admin@localhost -p 2222

# Develop in your persistent home directory
# Install packages: sudo apt-get install (admin only)

# Stop when done
docker-compose -f docker-compose.ubuntu.yml down
```

### Alpine Version (Recommended for Production)
```bash
# Start Alpine environment (82% smaller)
docker-compose -f docker-compose.alpine.yml up -d

# SSH into lab (same commands)
ssh admin@localhost -p 2222

# Develop in your persistent home directory
# Install packages: sudo apk add (admin only)

# Stop when done
docker-compose -f docker-compose.alpine.yml down
```

### Building Images
```bash
# Build Ubuntu image
docker-compose -f docker-compose.ubuntu.yml build

# Build Alpine image
docker-compose -f docker-compose.alpine.yml build

# Build both images
docker-compose -f docker-compose.ubuntu.yml build && docker-compose -f docker-compose.alpine.yml build
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

# Stop both environments
docker-compose -f docker-compose.ubuntu.yml down
docker-compose -f docker-compose.alpine.yml down
```

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

Both Ubuntu and Alpine versions include built-in health checks that monitor SSH service availability:

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
docker inspect student-lab-ubuntu | grep -A 20 "Health"

# Monitor health check logs
docker inspect student-lab-ubuntu | grep -A 10 "Healthcheck"
```

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

## 🏔️ Alpine vs Ubuntu Comparison

### Image Size Comparison
| Version | Base Image | Final Size | Size Reduction |
|---------|------------|------------|----------------|
| **Ubuntu** | `ubuntu:24.04` | 1.05GB | - |
| **Alpine** | `alpine:3.22` | 189MB | **82% smaller** |

### When to Use Each Version

**Use Alpine When:**
- Resource constraints are a concern
- Fast deployments are needed
- Security is a priority
- Production environments where size matters

**Use Ubuntu When:**
- Maximum compatibility is needed
- Familiar environment is preferred
- Specific Ubuntu packages are required
- Development/testing environments

### Key Differences
- **Package Management**: `apt` (Ubuntu) vs `apk` (Alpine)
- **Service Management**: `service` (Ubuntu) vs direct commands (Alpine)
- **User Groups**: `sudo` (Ubuntu) vs `wheel` (Alpine)
- **Build Time**: Alpine builds ~50% faster
- **Startup Time**: Alpine starts ~30% faster

### Resource Limits
Both versions are configured with optimized resource limits:
- **CPU**: Maximum 2 cores, minimum 1 core reserved
- **Memory**: Maximum 2GB, minimum 1GB reserved
- **Network**: Standard bridge networking
- **Storage**: Persistent volumes for user data

## 📚 Documentation

- **[Documentation Index](docs/index.md)**: Complete modular documentation
- **[Quick Start Guide](docs/getting-started/quick-start.md)**: Get up and running in minutes
- **[Project Structure](docs/getting-started/project-structure.md)**: Complete project overview
- **[Container Management](docs/administration/container-management.md)**: Docker container operations
- **[User Management](docs/user-management/user-accounts.md)**: User account management
- **[Remote Access](docs/remote-access/ssh-access.md)**: SSH access and tunneling
- **[Troubleshooting](docs/troubleshooting/common-issues.md)**: Common issues and solutions
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
docker-compose -f docker-compose.ubuntu.yml exec lab-environment-ubuntu service ssh status
```

**Environment variables not loading:**
```bash
# Verify .env file exists
ls -la .env

# Check variable resolution
docker-compose config | grep -E "(PLAYIT_SECRET_KEY|ADMIN_PASSWORD)"
```

For more detailed troubleshooting, see [Troubleshooting Guide](docs/troubleshooting/common-issues.md).

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
- **Documentation**: [Documentation Index](docs/index.md)

---

**Note**: This is a development and educational tool. Always follow security best practices and change default credentials before use in production environments. 