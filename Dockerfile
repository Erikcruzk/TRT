# Use the official Debian Slim base image
FROM python:3.11.3-slim-bullseye

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Import the Docker GPG key and add the Docker repository by adding the following lines:
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null


# Install Docker
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
RUN curl -fsSL https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Clean up the apt cache by adding the following line:
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# install pip requirements
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Copy the entire project directory to the container
COPY . .

# Install smartbugs
RUN git clone https://github.com/smartbugs/smartbugs
RUN cd smartbugs
RUN install/setup-venv.sh

# Set the entry point command to Shell
ENTRYPOINT ["/bin/bash"]