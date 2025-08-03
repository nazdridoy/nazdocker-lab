FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update package lists and install basic tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    jq \
    net-tools \
    iputils-ping \
    openssh-server \
    sudo \
    wget \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Create users (home directories will be mounted from host)
RUN useradd -s /bin/bash admin && \
    useradd -s /bin/bash user1 && \
    useradd -s /bin/bash user2 && \
    useradd -s /bin/bash user3 && \
    useradd -s /bin/bash user4 && \
    useradd -s /bin/bash user5

# Note: passwords will be set at runtime via environment variables

# Add admin to sudo group
RUN usermod -aG sudo admin

# Configure SSH
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Install playit.gg agent
RUN wget https://github.com/playit-cloud/playit-agent/releases/download/v0.16.2/playit-linux-amd64 && \
    mv playit-linux-amd64 /usr/local/bin/playit-agent && \
    chmod +x /usr/local/bin/playit-agent

# Create startup script
RUN echo '#!/bin/bash\n\
\n\
# Create home directories and set permissions\n\
mkdir -p /home/admin /home/user1 /home/user2 /home/user3 /home/user4 /home/user5\n\
chown admin:admin /home/admin\n\
chown user1:user1 /home/user1\n\
chown user2:user2 /home/user2\n\
chown user3:user3 /home/user3\n\
chown user4:user4 /home/user4\n\
chown user5:user5 /home/user5\n\
chmod 750 /home/admin /home/user1 /home/user2 /home/user3 /home/user4 /home/user5\n\
\n\
# Set passwords at runtime\n\
if [ -n "$ADMIN_PASSWORD" ]; then\n\
    echo "admin:$ADMIN_PASSWORD" | chpasswd\n\
else\n\
    echo "admin:admin123" | chpasswd\n\
fi\n\
\n\
if [ -n "$USER_PASSWORD" ]; then\n\
    echo "user1:$USER_PASSWORD" | chpasswd\n\
    echo "user2:$USER_PASSWORD" | chpasswd\n\
    echo "user3:$USER_PASSWORD" | chpasswd\n\
    echo "user4:$USER_PASSWORD" | chpasswd\n\
    echo "user5:$USER_PASSWORD" | chpasswd\n\
else\n\
    echo "user1:user123" | chpasswd\n\
    echo "user2:user123" | chpasswd\n\
    echo "user3:user123" | chpasswd\n\
    echo "user4:user123" | chpasswd\n\
    echo "user5:user123" | chpasswd\n\
fi\n\
\n\
# Set root password\n\
if [ -n "$ROOT_PASSWORD" ]; then\n\
    echo "root:$ROOT_PASSWORD" | chpasswd\n\
else\n\
    echo "root:root123" | chpasswd\n\
fi\n\
\n\
# Start SSH server\n\
service ssh start\n\
\n\
# Start playit.gg agent\n\
if [ -n "$PLAYIT_SECRET_KEY" ]; then\n\
    echo "Starting playit.gg agent..."\n\
    playit-agent --secret $PLAYIT_SECRET_KEY --stdout &\n\
else\n\
    echo "Warning: PLAYIT_SECRET_KEY not set. SSH will only be accessible locally."\n\
fi\n\
\n\
# Keep container running\n\
tail -f /dev/null' > /start.sh && \
    chmod +x /start.sh

# Expose SSH port
EXPOSE 22

# Set the default command
CMD ["/start.sh"] 