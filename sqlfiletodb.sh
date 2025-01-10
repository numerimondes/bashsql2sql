#!/bin/bash

# Log file for export and import
LOG_FILE="transfer.log"

# Ask the user for the required information
read -p "MySQL username (e.g., greatmaster): " TARGET_DB_USER
read -sp "MySQL password: " TARGET_DB_PASSWORD
echo  # for line break after password entry

read -p "Absolute path to the SQL file to import (e.g., /path/to/dodo.sql): " SOURCE_DB_PATH
read -p "Target database name: " TARGET_DB_NAME

TARGET_DB_HOST="localhost"
TARGET_DB_PORT="3306"

# Function to display messages in the terminal
print_message() {
  echo "$1"
}

# Function to import the SQL file into the target database
import_database() {
  echo "Starting the import of the database from '$SOURCE_DB_PATH' to '$TARGET_DB_NAME'..."

  # Check if the source SQL file is a valid SQL file
  if [[ ! -f "$SOURCE_DB_PATH" ]]; then
    print_message "Error: The file '$SOURCE_DB_PATH' does not exist."
    exit 1
  fi

  # Import the SQL file into the target database
  mysql -h "$TARGET_DB_HOST" -P "$TARGET_DB_PORT" -u "$TARGET_DB_USER" -p"$TARGET_DB_PASSWORD" "$TARGET_DB_NAME" < "$SOURCE_DB_PATH"

  # Check if the import was successful
  if [ $? -eq 0 ]; then
    print_message "Database import successful."
  else
    print_message "Error during database import."
    exit 1
  fi
}

# Function to warn about IP configuration and permissions
warn_ip_configuration() {
  print_message "WARNING: Ensure that your local IP address is authorized for database connection."
  print_message "If not, the operation will fail."
}

# Ask for confirmation before starting the import
print_message "This script will import the database from the file '$SOURCE_DB_PATH' to '$TARGET_DB_NAME'."
read -p "Do you want to continue? [y/n]: " CONTINUE

if [[ "$CONTINUE" != "y" && "$CONTINUE" != "Y" ]]; then
  print_message "Operation canceled."
  exit 0
fi

# Warn about IP configuration before proceeding
warn_ip_configuration

# Extract the table names from the SQL file
print_message "Extracting tables from the SQL file..."
TABLES=$(grep -oP 'CREATE TABLE \`\K[^`]+(?=\`)' "$SOURCE_DB_PATH")

# Check if tables were found in the SQL file
if [[ -z "$TABLES" ]]; then
  print_message "No tables found in the SQL file."
  exit 1
fi

# Notify the user about the tables to be imported
echo "Tables to be imported:"
echo "$TABLES"

# Import each table and notify after each one
for TABLE in $TABLES; do
  print_message "Importing table: $TABLE..."

  # Import the specific table into the target database
  sed -n "/^-- Table structure for table \`$TABLE\`/,/^-- Dump completed/p" "$SOURCE_DB_PATH" | \
  mysql -h "$TARGET_DB_HOST" -P "$TARGET_DB_PORT" -u "$TARGET_DB_USER" -p"$TARGET_DB_PASSWORD" "$TARGET_DB_NAME"

  if [ $? -eq 0 ]; then
    print_message "Table '$TABLE' imported successfully."
  else
    print_message "Error while importing table '$TABLE'."
  fi
done

echo "Import completed successfully."
