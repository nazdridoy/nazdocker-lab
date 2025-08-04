---
layout: default
title: SSH Key Synchronization
parent: Administration
nav_order: 7
permalink: /administration/ssh-key-sync/
---

# SSH Key Synchronization

This document explains how SSH keys are synchronized between Ubuntu and Alpine containers in the nazdocker-lab environment.

## Overview

Both Ubuntu and Alpine containers use the same SSH host keys, ensuring consistent SSH connections regardless of which container you connect to. This eliminates SSH host key warnings when switching between containers.

## Key Files

- **SSH Keys Location**: `config/ssh/`
- **Key Types**: RSA (4096-bit), ECDSA (521-bit), ED25519
- **Management Script**: `scripts/manage-ssh-keys.sh`

## How It Works

1. **Shared Keys**: All SSH host keys are stored in `config/ssh/` directory
2. **Build-time Copy**: SSH keys are copied during container build process
3. **Permissions**: Keys are automatically set to proper permissions (600 for private keys, 644 for public keys)

## Key Management

### Generate New SSH Keys

```bash
# Generate all SSH host keys
./scripts/manage-ssh-keys.sh generate
```

### Check Key Fingerprints

```bash
# View SSH key fingerprints
./scripts/manage-ssh-keys.sh check
```

### Backup SSH Keys

```bash
# Create backup of current SSH keys
./scripts/manage-ssh-keys.sh backup
```

### Restore SSH Keys

```bash
# Restore SSH keys from backup
./scripts/manage-ssh-keys.sh restore backup/ssh-20231201-143022
```

## Container Configuration

### Ubuntu Container
- **Dockerfile**: `Dockerfile.ubuntu`
- **Compose**: `docker-compose.ubuntu.yml`
- **SSH Keys**: Copied from `config/ssh/` to `/etc/ssh/` during build

### Alpine Container
- **Dockerfile**: `Dockerfile.alpine`
- **Compose**: `docker-compose.alpine.yml`
- **SSH Keys**: Copied from `config/ssh/` to `/etc/ssh/` during build

## Benefits

1. **Consistent Experience**: Same SSH host keys across both containers
2. **No Key Warnings**: SSH clients won't show host key warnings when switching containers
3. **Centralized Management**: All SSH keys managed in one location
4. **Easy Updates**: Change keys without rebuilding containers

## Security Considerations

- SSH keys are copied during build process for security
- Private keys have 600 permissions
- Public keys have 644 permissions
- Keys are stored outside containers for easy backup/restore
- SSH host keys are automatically gitignored for security

## Troubleshooting

### SSH Key Permissions
If you encounter permission issues:

```bash
# Fix permissions manually
chmod 600 config/ssh/ssh_host_*_key
chmod 644 config/ssh/ssh_host_*_key.pub
```

### Regenerate Keys
If you need to regenerate all SSH keys:

```bash
# Remove existing keys
rm -f config/ssh/ssh_host_*

# Generate new keys
./scripts/manage-ssh-keys.sh generate

# Rebuild containers with new keys
docker-compose -f docker-compose.ubuntu.yml down
docker-compose -f docker-compose.alpine.yml down
docker-compose -f docker-compose.ubuntu.yml up -d --build
docker-compose -f docker-compose.alpine.yml up -d --build
```

## File Structure

```
nazdocker-lab/
├── config/
│   └── ssh/
│       ├── ssh_host_rsa_key
│       ├── ssh_host_rsa_key.pub
│       ├── ssh_host_ecdsa_key
│       ├── ssh_host_ecdsa_key.pub
│       ├── ssh_host_ed25519_key
│       └── ssh_host_ed25519_key.pub
├── scripts/
│   └── manage-ssh-keys.sh
└── docs/
    └── administration/
        └── ssh-key-sync.md
``` 