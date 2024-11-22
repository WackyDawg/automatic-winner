# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install dependencies (Docker and Git)
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    sudo \
    git

# Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the Docker repository
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again and install Docker
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Test Docker installation by printing the version
RUN docker --version

# Install Git
RUN apt-get install -y git

# Set the default command to run when starting the container
CMD ["bash"]
