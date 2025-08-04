#!/bin/bash

# Create home directories and set permissions
mkdir -p /home/admin /home/user1 /home/user2 /home/user3 /home/user4 /home/user5
chown admin:admin /home/admin
chown user1:user1 /home/user1
chown user2:user2 /home/user2
chown user3:user3 /home/user3
chown user4:user4 /home/user4
chown user5:user5 /home/user5
chmod 750 /home/admin /home/user1 /home/user2 /home/user3 /home/user4 /home/user5


# Set passwords at runtime
if [ -n "$ADMIN_PASSWORD" ]; then
    echo "admin:$ADMIN_PASSWORD" | chpasswd
else
    echo "admin:admin123" | chpasswd
fi

if [ -n "$USER_PASSWORD" ]; then
    echo "user1:$USER_PASSWORD" | chpasswd
    echo "user2:$USER_PASSWORD" | chpasswd
    echo "user3:$USER_PASSWORD" | chpasswd
    echo "user4:$USER_PASSWORD" | chpasswd
    echo "user5:$USER_PASSWORD" | chpasswd
else
    echo "user1:user123" | chpasswd
    echo "user2:user123" | chpasswd
    echo "user3:user123" | chpasswd
    echo "user4:user123" | chpasswd
    echo "user5:user123" | chpasswd
fi

# Set root password
if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
else
    echo "root:root123" | chpasswd
fi

# Start SSH server
if command -v service >/dev/null 2>&1; then
    # Ubuntu/Debian style
    service ssh start
else
    # Alpine style
    /usr/sbin/sshd
fi

# Start playit.gg agent
if [ -n "$PLAYIT_SECRET_KEY" ]; then
    echo "Starting playit.gg agent..."
    playit-agent --secret $PLAYIT_SECRET_KEY --stdout &
else
    echo "Warning: PLAYIT_SECRET_KEY not set. SSH will only be accessible locally."
fi

# Keep container running
tail -f /dev/null 