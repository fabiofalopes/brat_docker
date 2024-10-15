#!/bin/bash

# Define variables
BRAT_ARCHIVE_URL="https://github.com/nlplab/brat/archive/refs/tags/v1.3p1.tar.gz"
BRAT_DOWNLOAD_DIR="brat"
VERSION_INFO_FILE="brat_version_info.txt"
DOCKERFILE_PATH="Dockerfile"
DOCKER_COMPOSE_PATH="docker-compose.yml"
APACHE_CONF_PATH="apache/"
BRAT_CONFIG_FILE="config.py"

# Download the BRAT source code
echo "Downloading BRAT source code..."
wget --show-progress $BRAT_ARCHIVE_URL -O brat.tar.gz

# Extract the downloaded archive
echo "Extracting BRAT source code..."
tar -xzf brat.tar.gz

# Find the extracted directory name
EXTRACTED_DIR_NAME=$(tar -tzf brat.tar.gz | head -1 | cut -f1 -d"/")

# Rename the extracted directory to 'brat'
echo "Renaming $EXTRACTED_DIR_NAME to $BRAT_DOWNLOAD_DIR..."
mv $EXTRACTED_DIR_NAME $BRAT_DOWNLOAD_DIR

# Create a text file with the version and download link
echo "Creating version info file..."
echo "Generated while extrating BRAT source code" > $VERSION_INFO_FILE
echo "Date and Time of extraction: $(date)" >> $VERSION_INFO_FILE
echo "Extracted Directory: $EXTRACTED_DIR_NAME" > $VERSION_INFO_FILE
echo "Download URL: $BRAT_ARCHIVE_URL" >> $VERSION_INFO_FILE

# Move Docker and configuration files into the BRAT directory
echo "Copying Docker and configuration files..."
cp $DOCKERFILE_PATH $BRAT_DOWNLOAD_DIR/
cp $DOCKER_COMPOSE_PATH $BRAT_DOWNLOAD_DIR/
cp -r $APACHE_CONF_PATH $BRAT_DOWNLOAD_DIR/
cp $BRAT_CONFIG_FILE $BRAT_DOWNLOAD_DIR/

# Clean up
echo "Cleaning up..."
rm brat.tar.gz

echo "Setup complete. Navigate to the $BRAT_DOWNLOAD_DIR directory to continue."
