#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker before running this script."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose version &> /dev/null; then
    echo "Error: Docker Compose is not installed. Please install Docker Compose before running this script."
    exit 1
fi

# Define the BRAT directory
BRAT_DIR="brat"

# Check if the BRAT directory exists
if [ ! -d "$BRAT_DIR" ]; then
  echo "Error: The BRAT directory '$BRAT_DIR' does not exist. Please run setup_brat.sh first."
  exit 1
fi

# Navigate to the BRAT directory
echo "Navigating to the BRAT directory..."
cd $BRAT_DIR

# Build the Docker image
echo "Building the Docker image..."
docker compose build

# Run the Docker container
echo "Starting the Docker container..."
docker compose up -d

echo "BRAT is now running. Access it at http://localhost:8066"
