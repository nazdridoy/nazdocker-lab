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

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose SSH port
EXPOSE 22

# Health check to monitor SSH availability
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD service ssh status >/dev/null 2>&1 || exit 1

# Set the default command
CMD ["/start.sh"] 