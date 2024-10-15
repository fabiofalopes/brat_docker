#!/bin/bash

# Define variables
BRAT_REPO_URL="https://github.com/nlplab/brat.git"
BRAT_DOWNLOAD_DIR="brat"
VERSION_INFO_FILE="brat_version_info.txt"
DOCKERFILE_PATH="Dockerfile"
DOCKER_COMPOSE_PATH="docker-compose.yml"

BRAT_FILES_DIR="brat_files"

BRAT_DATA_DIR="$BRAT_FILES_DIR/data/"
BRAT_WORK_DIR="$BRAT_FILES_DIR/work/"

APACHE_CONF_PATH="$BRAT_FILES_DIR/apache/"
BRAT_CONFIG_FILE="$BRAT_FILES_DIR/config.py"
BRAT_ANNOTATION_CONF="$BRAT_FILES_DIR/data/annotation.conf"
BRAT_ATTRIBUTES_CONF="$BRAT_FILES_DIR/attributes.conf"
EVENT_TYPES_CONF="$BRAT_FILES_DIR/event_types.conf"
KEYBOARD_SHORCUTS_CONF="$BRAT_FILES_DIR/data/kb_shortcuts.conf"
TOOLS_CONF="$BRAT_FILES_DIR/data/tools.conf"
VISUAL_CONF="$BRAT_FILES_DIR/data/visual.conf"

STYLE_UI_CSS="style-ui.css"
STYLE_VIS_CSS="style-vis.css"

TEST_SERVER_SCRIPT="testserver.py"

# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
  echo "Error: git is not installed." >&2
  exit 1
fi

# Clone the BRAT repository
echo "Cloning BRAT repository..."
git clone $BRAT_REPO_URL $BRAT_DOWNLOAD_DIR

# Check if clone was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to clone BRAT repository." >&2
  exit 1
fi

# Create a text file with the version and repo link
echo "Creating version info file..."
echo "Generated while cloning BRAT repository" > $VERSION_INFO_FILE
echo "Date and Time of cloning: $(date)" >> $VERSION_INFO_FILE
echo "Cloned Repository: $BRAT_REPO_URL" >> $VERSION_INFO_FILE
echo "Repository Directory: $BRAT_DOWNLOAD_DIR" >> $VERSION_INFO_FILE

# Move Docker and configuration files into the BRAT directory
echo "Copying Docker and configuration files..."
cp $DOCKERFILE_PATH $BRAT_DOWNLOAD_DIR/ # Dockerfile
cp $DOCKER_COMPOSE_PATH $BRAT_DOWNLOAD_DIR/ # docker-compose.yml
cp -r $APACHE_CONF_PATH $BRAT_DOWNLOAD_DIR/ # pasta apache com config
cp -r $BRAT_DATA_DIR $BRAT_DOWNLOAD_DIR/data # data dir
cp -r $BRAT_WORK_DIR $BRAT_DOWNLOAD_DIR/ # work dir
cp $BRAT_CONFIG_FILE $BRAT_DOWNLOAD_DIR/ # config.py
cp $BRAT_ANNOTATION_CONF $BRAT_DOWNLOAD_DIR/ # annotation.conf
cp $BRAT_ATTRIBUTES_CONF $BRAT_DOWNLOAD_DIR/ # attributes.conf
cp $EVENT_TYPES_CONF $BRAT_DOWNLOAD_DIR/ # event_types.conf
cp $KEYBOARD_SHORCUTS_CONF $BRAT_DOWNLOAD_DIR/ # kb_shortcuts.conf
cp $TOOLS_CONF $BRAT_DOWNLOAD_DIR/ # tools.conf
cp $VISUAL_CONF $BRAT_DOWNLOAD_DIR/ # visual.conf

echo "Setup complete. Run 'install_brat.sh' or navigate to the $BRAT_DOWNLOAD_DIR directory to continue."
