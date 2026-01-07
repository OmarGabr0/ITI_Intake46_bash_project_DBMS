#!/usr/bin/bash

# Main menu for database creation (Zenity version)

while true; do
    choice=$(zenity --list --title="Main Menu" \
        --column="Option" \
        "Create Database" \
        "List Databases" \
        "Connect To Database" \
        "Drop Database" \
        "Exit")

    # Exit if user cancels the menu
    if [ $? -ne 0 ]; then
        exit 0
    fi

    case "$choice" in
        "Create Database")
            source ./create_database.sh
            ;;
        "List Databases")
            dbs=$(ls ../Databases 2>/dev/null)
            if [ -z "$dbs" ]; then
                dbs="No databases found."
            fi
            zenity --info --title="Databases" --text="$dbs"
            ;;
        "Connect To Database")
            source ./connect_to_database.sh
            ;;
        "Drop Database")
            source ./drop_database.sh
            ;;
        "Exit")
            zenity --info --text="Thanks for your time :)"
            exit 0
            ;;
        *)
            zenity --error --text="Invalid option!"
            ;;
    esac

    # Small pause and separator (optional)
    sleep 0.5
done
