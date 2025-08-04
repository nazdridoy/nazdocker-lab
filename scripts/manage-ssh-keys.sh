#!/bin/bash

# SSH Key Management Script for nazdocker-lab
# This script helps manage shared SSH keys between Ubuntu and Alpine containers

set -e

SSH_CONFIG_DIR="config/ssh"
SSH_KEYS=(
    "ssh_host_rsa_key"
    "ssh_host_ecdsa_key" 
    "ssh_host_ed25519_key"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to generate SSH keys
generate_keys() {
    print_status "Generating SSH host keys..."
    
    mkdir -p "$SSH_CONFIG_DIR"
    
    # Generate RSA key (4096 bits)
    if [ ! -f "$SSH_CONFIG_DIR/ssh_host_rsa_key" ]; then
        print_status "Generating RSA key..."
        ssh-keygen -t rsa -b 4096 -f "$SSH_CONFIG_DIR/ssh_host_rsa_key" -N ""
    else
        print_warning "RSA key already exists"
    fi
    
    # Generate ECDSA key (521 bits)
    if [ ! -f "$SSH_CONFIG_DIR/ssh_host_ecdsa_key" ]; then
        print_status "Generating ECDSA key..."
        ssh-keygen -t ecdsa -b 521 -f "$SSH_CONFIG_DIR/ssh_host_ecdsa_key" -N ""
    else
        print_warning "ECDSA key already exists"
    fi
    
    # Generate ED25519 key
    if [ ! -f "$SSH_CONFIG_DIR/ssh_host_ed25519_key" ]; then
        print_status "Generating ED25519 key..."
        ssh-keygen -t ed25519 -f "$SSH_CONFIG_DIR/ssh_host_ed25519_key" -N ""
    else
        print_warning "ED25519 key already exists"
    fi
    
    # Set proper permissions
    print_status "Setting proper permissions..."
    chmod 600 "$SSH_CONFIG_DIR"/ssh_host_*_key
    chmod 644 "$SSH_CONFIG_DIR"/ssh_host_*_key.pub
    
    print_status "SSH keys generated successfully!"
}

# Function to check SSH key fingerprints
check_fingerprints() {
    print_status "SSH Key Fingerprints:"
    echo "================================"
    
    for key in "${SSH_KEYS[@]}"; do
        if [ -f "$SSH_CONFIG_DIR/$key" ]; then
            echo "$key:"
            ssh-keygen -lf "$SSH_CONFIG_DIR/$key"
            echo ""
        else
            print_error "Key $key not found!"
        fi
    done
}

# Function to backup SSH keys
backup_keys() {
    local backup_dir="backup/ssh-$(date +%Y%m%d-%H%M%S)"
    print_status "Creating backup in $backup_dir..."
    
    mkdir -p "$backup_dir"
    cp -r "$SSH_CONFIG_DIR"/* "$backup_dir/"
    
    print_status "Backup created successfully!"
}

# Function to restore SSH keys from backup
restore_keys() {
    if [ -z "$1" ]; then
        print_error "Please specify backup directory"
        echo "Usage: $0 restore <backup_directory>"
        exit 1
    fi
    
    local backup_dir="$1"
    if [ ! -d "$backup_dir" ]; then
        print_error "Backup directory $backup_dir does not exist"
        exit 1
    fi
    
    print_status "Restoring SSH keys from $backup_dir..."
    cp -r "$backup_dir"/* "$SSH_CONFIG_DIR/"
    chmod 600 "$SSH_CONFIG_DIR"/ssh_host_*_key
    chmod 644 "$SSH_CONFIG_DIR"/ssh_host_*_key.pub
    
    print_status "SSH keys restored successfully!"
}

# Function to show usage
show_usage() {
    echo "SSH Key Management Script for nazdocker-lab"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  generate    Generate new SSH host keys"
    echo "  check       Check SSH key fingerprints"
    echo "  backup      Create backup of current SSH keys"
    echo "  restore     Restore SSH keys from backup"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 generate"
    echo "  $0 check"
    echo "  $0 backup"
    echo "  $0 restore backup/ssh-20231201-143022"
}

# Main script logic
case "${1:-help}" in
    generate)
        generate_keys
        ;;
    check)
        check_fingerprints
        ;;
    backup)
        backup_keys
        ;;
    restore)
        restore_keys "$2"
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac 