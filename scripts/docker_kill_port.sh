#!/bin/bash

# Check if a port number is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <port>"
    exit 1
fi

# Get the port number from the argument
PORT="$1"

# Find the container ID using ss and awk
CONTAINER_ID=$(ss -tuln | awk -v port="$PORT" '$4 ~ ":"port"$" {print $7}' | cut -d'/' -f1)

# Check if a container ID was found
if [ -z "$CONTAINER_ID" ]; then
    echo "No Docker container found running on port $PORT"
    exit 1
fi

# Stop and remove the Docker container
docker stop "$CONTAINER_ID"
docker rm "$CONTAINER_ID"

echo "Docker container running on port $PORT (Container ID: $CONTAINER_ID) has been stopped and removed."

