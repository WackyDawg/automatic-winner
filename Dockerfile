# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install dependencies (Docker, Git, curl)
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

# Check if the Docker Compose installation is correct by running the version command
RUN /usr/local/bin/docker-compose --version

# Test Docker installation by printing the version
RUN docker --version

# Clone the repository into /app
RUN git clone https://github.com/WackyDawg/automatic-winner.git /app

# Change the working directory to the cloned repository
WORKDIR /app

# List the contents of the /app/automatic-winner directory to confirm the files are there
RUN ls -alh

# Run docker-compose to start services defined in the docker-compose.yml file
RUN docker build -t ubuntu-docker-compose .

# Set the default command to run when starting the container
CMD ["bash"]
