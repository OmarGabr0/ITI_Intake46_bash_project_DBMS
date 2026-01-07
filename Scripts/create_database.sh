#!/usr/bin/bash

# Sources section
source repeating_functions.sh

# First, check if the "Databases" folder exists
check_if_exists d ../Databases
if [ $? -eq 0 ]; then
    mkdir ../Databases
fi

while true; do
    # Ask user the database name using Zenity
    DB_name=$(zenity --entry --title="Create Database" --text="Enter database name:")

    # Exit if user cancels
    if [ $? -ne 0 ]; then
        exit 0
    fi

    # Check for empty input
    is_empty "$DB_name"
    res=$?
    if [ $res -eq 1 ]; then
        zenity --error --title="Error" --text="System doesn't accept empty inputs"
        continue
    fi

    # Validate database name pattern
    if [[ ! $DB_name =~ ^[A-Za-z][A-Za-z0-9_-]*$ ]]; then
        zenity --error --title="Error" --text="Invalid database name! Must start with a letter and contain only letters, numbers, - or _"
        continue
    fi

    # Check if database already exists
    check_if_exists d ../Databases/"$DB_name"
    if [ $? -eq 1 ]; then
        zenity --error --title="Error" --text="Database '$DB_name' already exists!"
        continue
    fi

    # Create the database folder
    mkdir ../Databases/"$DB_name"
    zenity --info --title="Success" --text="Database '$DB_name' created successfully!"
    break
done
