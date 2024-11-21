#!/bin/bash

# Function to get the IP address of the Ubuntu machine
get_ip_address() {
  if command -v ifconfig > /dev/null 2>&1; then
    # Use `ifconfig` to find the IP
    ifconfig | grep -A1 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1
  elif command -v ip > /dev/null 2>&1; then
    # Use `ip` to find the IP
    ip -4 addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | head -n 1
  else
    echo "127.0.0.1"  # Fallback to localhost
  fi
}

# Fetch the IP address
IP_ADDR=$(get_ip_address)
if [ -z "$IP_ADDR" ]; then
  IP_ADDR="127.0.0.1"
fi

# Define container and image names
MYSQL_CONTAINER="orthovenn3-mysql"
API_CONTAINER="orthovenn3-api"
WEB_CONTAINER="orthovenn3-web"
MYSQL_IMAGE="lufang0411/orthovenn3-mysql:latest"
API_IMAGE="lufang0411/orthovenn3-api:latest"
WEB_IMAGE="leeoluo/orthovenn3-front:latest"

# Define ports and data paths
MYSQL_ROOT_PASSWORD="123456Aa"
WEB_PORT="9998"
API_PORT="8102"
API_SSH_PORT="8122"
DATA_PATH="/opt/orthovenn3/data"
MYSQL_PATH="$DATA_PATH/mysql"
API_RESULT_PATH="$DATA_PATH/api/result"
API_WORK_PATH="$DATA_PATH/api/work"

# Print detected IP address
echo "Detected IP Address: $IP_ADDR"

# Ensure necessary directories exist
echo "Creating data directories..."
sudo mkdir -p "$MYSQL_PATH" "$API_RESULT_PATH" "$API_WORK_PATH"
sudo chmod -R 777 "$DATA_PATH"

# Pull required Docker images
echo "Pulling Docker images..."
docker pull $MYSQL_IMAGE
docker pull $API_IMAGE
docker pull $WEB_IMAGE

# Stop and remove any existing containers
echo "Cleaning up old containers..."
docker stop $MYSQL_CONTAINER $API_CONTAINER $WEB_CONTAINER 2>/dev/null
docker rm $MYSQL_CONTAINER $API_CONTAINER $WEB_CONTAINER 2>/dev/null

# Start MySQL container
echo "Starting MySQL container..."
docker run --privileged \
  --restart=always \
  --name $MYSQL_CONTAINER \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -v "$MYSQL_PATH:/var/lib/mysql" \
  -d $MYSQL_IMAGE

# Start API container
echo "Starting API container..."
docker run -dit \
  --restart=always \
  -p $API_PORT:$API_PORT \
  -p $API_SSH_PORT:22 \
  --name $API_CONTAINER \
  --link $MYSQL_CONTAINER \
  -v "$API_RESULT_PATH:/home/orthovenn3/result" \
  -v "$API_WORK_PATH:/home/orthovenn3/work" \
  $API_IMAGE /docker-entrypoint.sh

# Start Web container
echo "Starting Web container..."
docker run -d \
  --restart=always \
  -p $WEB_PORT:80 \
  --name $WEB_CONTAINER \
  --link $API_CONTAINER \
  -e API_URL=http://$IP_ADDR:$API_PORT \
  -v "$API_RESULT_PATH:/data/orthovenn3/api/result" \
  $WEB_IMAGE

# Verify all containers are running
echo "Checking running containers..."
docker ps

# Provide access information
echo ""
echo "===================================================="
echo "OrthoVenn3 is now running!"
echo "Access it in your browser at: http://$IP_ADDR:$WEB_PORT"
echo "===================================================="
