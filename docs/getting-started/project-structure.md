---
layout: default
title: Project Structure
parent: Getting Started
nav_order: 2
permalink: /getting-started/project-structure/
---

# Project Structure

Complete overview of NazDocker Lab project structure and file organization.

## 📁 Project Structure

```
nazdocker-lab/                                                                     
├── Dockerfile.ubuntu           # Ubuntu container definition                      
├── Dockerfile.alpine           # Alpine container definition                      
├── start.sh                    # Cross-platform startup script                    
├── docker-compose.ubuntu.yml   # Ubuntu Docker Compose orchestration              
├── docker-compose.alpine.yml   # Alpine Docker Compose orchestration              
├── .env.example                # Environment variables template                   
├── README.md                   # Project documentation                            
├── MANAGEMENT.md               # Legacy comprehensive guide                       
├── LICENSE                     # GPL v3 license                                   
├── data/                       # Persistent user data (separated by container type)
│   ├── alpine/                 # Alpine container data                            
│   │   ├── admin/              # Admin home directory (Alpine)                    
│   │   ├── user1/              # User1 home directory (Alpine)                    
│   │   ├── user2/              # User2 home directory (Alpine)                    
│   │   ├── user3/              # User3 home directory (Alpine)                    
│   │   ├── user4/              # User4 home directory (Alpine)                    
│   │   └── user5/              # User5 home directory (Alpine)                    
│   └── ubuntu/                 # Ubuntu container data                            
│       ├── admin/              # Admin home directory (Ubuntu)                    
│       ├── user1/              # User1 home directory (Ubuntu)                    
│       ├── user2/              # User2 home directory (Ubuntu)                    
│       ├── user3/              # User3 home directory (Ubuntu)                    
│       ├── user4/              # User4 home directory (Ubuntu)                    
│       └── user5/              # User5 home directory (Ubuntu)                    
├── logs/                       # Application logs (separated by container type)   
│   ├── alpine/                 # Alpine container logs                            
│   └── ubuntu/                 # Ubuntu container logs                            
├── config/                     # Configuration files                              
│   └── ssh/                    # SSH configuration                                
└── docs/                       # Modular documentation                            
    ├── README.md               # Documentation index                              
    ├── getting-started/        # Getting started guides                           
    ├── user-management/        # User management guides                           
    ├── administration/         # Administration guides                            
    ├── remote-access/          # Remote access guides                             
    ├── development/            # Development guides                               
    ├── security/               # Security guides                                  
    ├── alpine-ubuntu/          # Alpine vs Ubuntu guides                          
    ├── troubleshooting/        # Troubleshooting guides                           
    └── maintenance/            # Maintenance guides                               

```

## 🔧 Key Files Explained

### Container Definitions

#### `Dockerfile.ubuntu`
**Purpose**: Ubuntu container definition with health checks and user setup
**Key Features**:
- Base image: `ubuntu:24.04`
- SSH server installation and configuration
- User account creation (admin, user1-user5, root)
- Health checks for SSH service availability
- Cross-platform startup script integration
- Package management with apt

**Key Sections**:
```dockerfile
# Install essential packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create users
RUN useradd -m -s /bin/bash admin && \
    echo "admin:admin123" | chpasswd && \
    usermod -aG sudo admin

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD service ssh status || exit 1
```

#### `Dockerfile.alpine`
**Purpose**: Alpine container definition (82% smaller, 189MB)
**Key Features**:
- Base image: `alpine:3.22`
- Minimal footprint for resource-constrained environments
- Package management with apk
- Same functionality as Ubuntu version
- Optimized for security and performance

**Key Sections**:
```dockerfile
# Install essential packages
RUN apk add --no-cache \
    openssh \
    sudo \
    curl \
    wget

# Create users
RUN adduser -D -s /bin/bash admin && \
    echo "admin:admin123" | passwd admin && \
    addgroup admin wheel

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD pgrep sshd || exit 1
```

### Orchestration Files

#### `docker-compose.ubuntu.yml`
**Purpose**: Ubuntu Docker Compose orchestration and volume management
**Key Features**:
- Container orchestration for Ubuntu version
- Volume mapping for persistent data
- Port mapping for SSH access
- Environment variable integration
- Health check monitoring
- Resource limits configuration

**Key Sections**:
```yaml
services:
  lab-environment-ubuntu:
    build:
      context: .
      dockerfile: Dockerfile.ubuntu
    ports:
      - "${SSH_PORT:-2222}:22"
    volumes:
      - ./data:/home
      - ./logs:/var/log
    environment:
      - PLAYIT_SECRET_KEY=${PLAYIT_SECRET_KEY}
    healthcheck:
      test: ["CMD", "service", "ssh", "status"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

#### `docker-compose.alpine.yml`
**Purpose**: Alpine Docker Compose orchestration and volume management
**Key Features**:
- Container orchestration for Alpine version
- Same volume and port mapping as Ubuntu
- Optimized for smaller resource footprint
- Alpine-specific health checks

### Configuration Files

#### `start.sh`
**Purpose**: Cross-platform startup script for runtime configuration
**Key Features**:
- User account creation and password management
- SSH service initialization
- Playit.gg tunnel setup
- Home directory permissions
- Environment variable processing
- Health check integration

**Key Functions**:
```bash
# User management
create_users() {
    # Create all user accounts
    # Set passwords from environment variables
    # Configure home directories
}

# SSH setup
setup_ssh() {
    # Start SSH service
    # Configure SSH settings
    # Set up authorized keys
}

# Tunnel management
setup_tunnel() {
    # Initialize playit.gg tunneling
    # Configure tunnel settings
    # Monitor tunnel status
}
```

#### `.env.example`
**Purpose**: Template for environment variable configuration
**Key Variables**:
```bash
# Playit.gg Configuration
PLAYIT_SECRET_KEY=your_secret_key_here

# User Passwords
ADMIN_PASSWORD=admin123
USER_PASSWORD=user123
ROOT_PASSWORD=root123

# SSH Configuration
SSH_PORT=2222
```

### Data Directories

#### `data/`
**Purpose**: Persistent storage for user home directories
**Structure**:
```
data/
├── admin/            # Admin user home directory
│   ├── Documents/    # User documents
│   ├── Downloads/    # Downloaded files
│   ├── Projects/     # User projects
│   └── .ssh/         # SSH keys and configuration
├── user1/            # User1 home directory
├── user2/            # User2 home directory
├── user3/            # User3 home directory
├── user4/            # User4 home directory
└── user5/            # User5 home directory
```

**Key Features**:
- Persistent across container restarts
- Individual user isolation
- Automatic permission management
- Backup and restore support

#### `logs/`
**Purpose**: Application and service logs
**Contents**:
- SSH service logs
- System logs
- Application logs
- Error logs
- Access logs

#### `config/`
**Purpose**: Configuration files and settings
**Structure**:
```
config/
└── ssh/                # SSH configuration
    ├── sshd_config     # SSH server configuration
    ├── authorized_keys # SSH public keys
    └── known_hosts     # Known host keys
```

### Documentation Structure

#### `docs/`
**Purpose**: Modular documentation system
**Structure**:
```
docs/                                                          
├── README.md                     # Documentation index        
├── getting-started/              # Getting started guides     
│   ├── quick-start.md            # Quick start guide          
│   └── project-structure.md      # This file                  
├── user-management/              # User management guides     
│   ├── user-accounts.md          # User account management    
│   ├── passwords.md              # Password management        
│   └── ssh-keys.md               # SSH key setup              
├── administration/               # Administration guides      
│   ├── container-management.md   # Container operations       
│   ├── environment-variables.md  # Configuration management   
│   ├── health-monitoring.md      # System health monitoring   
│   ├── backup-recovery.md        # Data backup and restoration
│   ├── advanced-configuration.md # Advanced configuration     
│   └── useful-scripts.md         # Management scripts         
├── remote-access/                # Remote access guides       
│   ├── ssh-access.md             # SSH access guide           
│   └── playit-tunneling.md       # Playit.gg tunneling        
├── development/                  # Development guides         
│   └── available-tools.md        # Available development tools
├── security/                     # Security guides            
│   └── security-overview.md      # Security architecture      
├── alpine-ubuntu/                # Alpine vs Ubuntu guides    
│   └── comparison.md             # Detailed comparison        
├── troubleshooting/              # Troubleshooting guides     
│   ├── common-issues.md          # Common problems            
│   ├── diagnostics.md            # Diagnostic commands        
│   └── emergency.md              # Emergency procedures       
└── maintenance/                  # Maintenance guides         
    └── regular-maintenance.md    # Maintenance procedures     
```

## 📋 File Purposes and Relationships

### Core Files

| File | Purpose | Dependencies |
|------|---------|--------------|
| `Dockerfile.ubuntu` | Ubuntu container definition | `start.sh` |
| `Dockerfile.alpine` | Alpine container definition | `start.sh` |
| `start.sh` | Runtime configuration script | Environment variables |
| `docker-compose.ubuntu.yml` | Ubuntu orchestration | `Dockerfile.ubuntu`, `.env` |
| `docker-compose.alpine.yml` | Alpine orchestration | `Dockerfile.alpine`, `.env` |
| `.env.example` | Environment template | None |

### Data Files
| Directory | Purpose | Persistence |
|-----------|---------|-------------|
| `data/` | User home directories | Persistent |
| `logs/` | Application logs | Persistent |
| `config/` | Configuration files | Persistent |

### Documentation Files
| Directory | Purpose | Coverage |
|-----------|---------|----------|
| `docs/` | Modular documentation | Complete MANAGEMENT.md coverage |
| `README.md` | Project overview | Quick start and features |
| `MANAGEMENT.md` | Legacy comprehensive guide | Being replaced by modular docs |

## 🔗 File Relationships

### Build Process
```
.env → docker-compose.yml → Dockerfile → start.sh → Container
```

### Data Flow
```
Host data/ → Container /home → Persistent storage
Host logs/ → Container /var/log → Log collection
Host config/ → Container /etc → Configuration
```

### Documentation Flow
```
MANAGEMENT.md → Modular docs/ → Organized by topic
```

## 📊 File Size Comparison

| File Type | Ubuntu Version | Alpine Version | Size Reduction |
|-----------|---------------|----------------|----------------|
| **Base Image** | `ubuntu:24.04` | `alpine:3.22` | 82% smaller |
| **Final Size** | 1.05GB | 189MB | 861MB saved |
| **Build Time** | ~3 minutes | ~1.5 minutes | 50% faster |
| **Startup Time** | ~30 seconds | ~20 seconds | 33% faster |

## 🔧 Configuration Management

### Environment Variables
- **Centralized Configuration**: All settings in `.env` file
- **Security**: Sensitive data kept out of version control
- **Flexibility**: Easy configuration changes without rebuilds
- **Templating**: `.env.example` provides setup guidance

### Volume Management
- **Data Persistence**: User data survives container restarts
- **Performance**: Optimized volume mounting with delegated mode
- **Backup**: Easy backup and restore of user data
- **Isolation**: Individual user directories for security

### Health Monitoring
- **Built-in Checks**: SSH service availability monitoring
- **Resource Monitoring**: CPU, memory, and disk usage
- **Log Analysis**: Comprehensive logging for troubleshooting
- **Alert System**: Health status reporting

## 🔗 Related Topics

- **[Quick Start Guide](quick-start.md)** - Getting started with the lab
- **[Container Management](../administration/container-management.md)** - Managing containers
- **[Environment Variables](../administration/environment-variables.md)** - Configuration management
- **[Backup and Recovery](../administration/backup-recovery.md)** - Data protection
- **[Alpine vs Ubuntu Comparison](../alpine-ubuntu/comparison.md)** - Version differences