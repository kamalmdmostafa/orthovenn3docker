
# OrthoVenn3 Setup Script for Dedicated Ubuntu Servers

This repository provides a universal script to install, configure, and run **OrthoVenn3**, a powerful tool for orthologous gene cluster analysis, on a dedicated Ubuntu Linux server. The script automates the setup process, ensuring easy and reproducible deployments.

---

## Features

- **Automatic IP Detection**: The script dynamically detects the server's IP address for seamless configuration.
- **Portable**: Designed for dedicated Ubuntu servers with Docker installed.
- **Cleans Up Old Containers**: Stops and removes previous OrthoVenn3 containers to prevent conflicts.
- **Customizable Paths and Ports**: Easily adjust data paths and port configurations to suit your environment.

---

## Prerequisites

1. **Ubuntu Server**:
   - Tested on Ubuntu 20.04 and 22.04.
   - Root or `sudo` access required.

2. **Docker**:
   - Install Docker if not already available:
     ```bash
     sudo apt update
     sudo apt install -y docker.io
     sudo systemctl start docker
     sudo systemctl enable docker
     ```
   - Verify Docker is installed:
     ```bash
     docker --version
     ```

---

## Installation and Usage

### Step 1: Clone the Repository
Clone this repository to your server:
```bash
git clone https://github.com/<your-username>/orthovenn3-setup.git
cd orthovenn3-setup
```

### Step 2: Make the Script Executable
Give the script execution permissions:
```bash
chmod +x run_orthovenn3_ubuntu.sh
```

### Step 3: Run the Script
Execute the script to set up OrthoVenn3:
```bash
sudo ./run_orthovenn3_ubuntu.sh
```

### Step 4: Access OrthoVenn3
After the script completes, access OrthoVenn3 in your browser at:
```
http://<server-ip>:9998
```
The script will display the correct IP address in its output.

---

## Script Details

The script performs the following tasks:

1. Detects the IP address of the server.
2. Creates necessary data directories in `/opt/orthovenn3/data`.
3. Pulls the required Docker images for MySQL, Web API, and Web Front.
4. Cleans up old containers to prevent conflicts.
5. Starts the MySQL, API, and Web Front containers with proper configurations.
6. Outputs the URL to access the OrthoVenn3 web interface.

---

## Configuration

### Default Settings
- **MySQL Password**: `123456Aa`
- **Data Directory**: `/opt/orthovenn3/data`
  - MySQL data: `/opt/orthovenn3/data/mysql`
  - API results: `/opt/orthovenn3/data/api/result`
  - API work: `/opt/orthovenn3/data/api/work`
- **Ports**:
  - Web: `9998`
  - API: `8102`
  - API SSH: `8122`

### Customization
To customize, edit the following variables in the script:
- `DATA_PATH`
- `WEB_PORT`, `API_PORT`, and `API_SSH_PORT`
- `MYSQL_ROOT_PASSWORD`

---

## Stopping and Removing Containers

To stop the OrthoVenn3 services:
```bash
docker stop orthovenn3-mysql orthovenn3-api orthovenn3-web
```

To remove the containers:
```bash
docker rm orthovenn3-mysql orthovenn3-api orthovenn3-web
```

To remove the images:
```bash
docker rmi lufang0411/orthovenn3-mysql:latest lufang0411/orthovenn3-api:latest leeoluo/orthovenn3-front:latest
```

---

## Troubleshooting

1. **Containers Not Starting**:
   - Check the logs:
     ```bash
     docker logs <container-name>
     ```

2. **Cannot Access Web Interface**:
   - Ensure Docker is running:
     ```bash
     sudo systemctl start docker
     ```
   - Verify the server IP address and ensure it's reachable.

3. **Firewall Issues**:
   - Allow traffic to the required ports (`9998`, `8102`, `8122`):
     ```bash
     sudo ufw allow 9998
     sudo ufw allow 8102
     sudo ufw allow 8122
     ```

---

## Contributions

Contributions, issues, and feature requests are welcome! Feel free to fork and submit pull requests.

---
