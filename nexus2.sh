#!/bin/bash

# Update and install dependencies
sudo yum update -y
sudo yum install wget -y

# Install Java (you installed only JMODS before, which is incomplete for runtime)
sudo yum install java-17-amazon-corretto -y

# Create application directory
sudo mkdir -p /app && cd /app

# Download and extract Nexus
sudo wget https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz
sudo tar -xvf nexus-3.79.1-04-linux-x86_64.tar.gz
sudo mv nexus-3.79.1-04 nexus

# Create nexus user (only if not exists)
id -u nexus &>/dev/null || sudo adduser nexus

# Fix ownership
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

# Set run_as_user properly in nexus script
sudo sed -i 's/^#run_as_user=""/run_as_user="nexus"/' /app/nexus/bin/nexus

# Create systemd service
sudo tee /etc/systemd/system/nexus.service > /dev/null << EOL
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus

# Check status
sudo systemctl status nexus
