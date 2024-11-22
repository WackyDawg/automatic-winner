# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install dependencies (Docker, Git, and curl)
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    sudo \
    git \
    python3 \
    python3-pip \
    && apt-get clean

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Test Docker installation by printing the version
RUN docker --version

# Clone a specific Git repository
RUN git clone https://github.com/WackyDawg/automatic-winner.git /app

# Change to the repo directory and run docker-compose
WORKDIR /app

# Run docker-compose to start services defined in the docker-compose.yml file
RUN docker-compose up -d

# Install Git
RUN apt-get install -y git

# Fetch and display the public IP
RUN curl -s ifconfig.me && echo " Public IP fetched successfully."

# Set the default command to run when starting the container
CMD ["bash"]
