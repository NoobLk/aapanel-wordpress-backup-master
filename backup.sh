#!/bin/bash

# Enable error handling
set -e

# SSH Key and Server details
SSH_KEY="~/.ssh/ssh.key"
SSH_USER="root"
SSH_HOST="35.154.153.48"
DEFAULT_DIR="/www/wwwroot"
LOCAL_BACKUP_DIR="./backups"

# Ask for folder name
read -p "Enter the folder name: " FOLDER_NAME

# Validate input
if [[ -z "$FOLDER_NAME" ]]; then
  echo "Error: Folder name cannot be empty!"
  exit 1
fi

# Define paths
BACKUP_PATH="$DEFAULT_DIR/$FOLDER_NAME"
BACKUP_FILE="$FOLDER_NAME-$(date +%Y%m%d-%H%M%S).tar.gz"
SQL_DUMP_FILE="$FOLDER_NAME-db-$(date +%Y%m%d-%H%M%S).sql"

# Create local backup folder
mkdir -p "$LOCAL_BACKUP_DIR/$FOLDER_NAME"

# SSH into the server
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" << EOF
  if [ ! -d "$BACKUP_PATH" ]; then
    echo "Error: Folder $BACKUP_PATH does not exist!"
    exit 1
  fi

  # Find wp-config.php inside the folder
  WP_CONFIG_PATH=\$(find "$BACKUP_PATH" -name "wp-config.php" | head -n 1)

  if [ -z "\$WP_CONFIG_PATH" ]; then
    echo "Error: wp-config.php not found!"
    exit 1
  fi

  echo "Found wp-config.php at: \$WP_CONFIG_PATH"

  # Extract database details from wp-config.php
  DB_NAME=\$(grep -oP "define\\( *'DB_NAME', *'\\K[^']+" "\$WP_CONFIG_PATH")
  DB_USER=\$(grep -oP "define\\( *'DB_USER', *'\\K[^']+" "\$WP_CONFIG_PATH")
  DB_PASS=\$(grep -oP "define\\( *'DB_PASSWORD', *'\\K[^']+" "\$WP_CONFIG_PATH")

  if [[ -z "\$DB_NAME" || -z "\$DB_USER" || -z "\$DB_PASS" ]]; then
    echo "Error: Could not extract database details!"
    exit 1
  fi

  echo "Database Name: \$DB_NAME"
  echo "Dumping database \$DB_NAME..."

  # Dump the database safely
  mysqldump --single-transaction --quick --no-tablespaces -u"\$DB_USER" -p"\$DB_PASS" "\$DB_NAME" > "$BACKUP_PATH/$SQL_DUMP_FILE"

  if [[ ! -f "$BACKUP_PATH/$SQL_DUMP_FILE" ]]; then
    echo "Error: Failed to dump database!"
    exit 1
  fi

  echo "Database dump created: $BACKUP_PATH/$SQL_DUMP_FILE"

  sleep 15

  # Create the tar.gz backup of the website folder
  cd "$BACKUP_PATH"
  tar -czvf "$BACKUP_FILE" .

  echo "Backup created: $BACKUP_PATH/$BACKUP_FILE"
EOF

# Download the backup files to local machine
scp -i "$SSH_KEY" "$SSH_USER@$SSH_HOST:$BACKUP_PATH/$BACKUP_FILE" "$LOCAL_BACKUP_DIR/$FOLDER_NAME/"
if [[ $? -ne 0 ]]; then
  echo "Error downloading file: $BACKUP_FILE"
  exit 1
fi

scp -i "$SSH_KEY" "$SSH_USER@$SSH_HOST:$BACKUP_PATH/$SQL_DUMP_FILE" "$LOCAL_BACKUP_DIR/$FOLDER_NAME/"
if [[ $? -ne 0 ]]; then
  echo "Error downloading file: $SQL_DUMP_FILE"
  exit 1
fi

echo "Backup successfully downloaded to $LOCAL_BACKUP_DIR/$FOLDER_NAME/"
